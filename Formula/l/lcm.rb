class Lcm < Formula
  desc "Libraries and tools for message passing and data marshalling"
  homepage "https://lcm-proj.github.io/"
  url "https://github.com/lcm-proj/lcm/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "590a7d996daa3d33a7f3094e4054c35799a3d7a4780d732be78971323e730eeb"
  license "LGPL-2.1-or-later"
  head "https://github.com/lcm-proj/lcm.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cc44fb36fd52595d8ab65e7e9267de9419fb80c041cf29e74913ca26a3cd86f8"
    sha256 cellar: :any,                 arm64_monterey: "6ba463959fd49363524127fcee429ffe119a691c8413f9e42df797ef0d717f18"
    sha256 cellar: :any,                 arm64_big_sur:  "f75a796ff74405bfff348ae1064d6ac0f5678ecbfddfc26b02ff673ce7dbc327"
    sha256 cellar: :any,                 ventura:        "865f99f4c08dde897d55f520fa8aa7d3a9df84240c9281399cb2d7519452c6b5"
    sha256 cellar: :any,                 monterey:       "dcf73c2d73c974c3df43107b82ba8eea223e3cfa1bcf10529966137f4b135b1a"
    sha256 cellar: :any,                 big_sur:        "d2140ed962ef6ce8136e72d19fdaf2b4604616b673886b10f0895441e5ed3a7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eee0f6f8f16a72525db3c926aeb9bf1860df1a5d031c9aed396bfda055c05114"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "lua"
  depends_on "openjdk"
  depends_on "python@3.11"

  def install
    # Adding RPATH in #{lib}/lua/X.Y/lcm.so and some #{bin}/*.
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{lib}
      -DLCM_ENABLE_EXAMPLES=OFF
      -DLCM_ENABLE_TESTS=OFF
      -DLCM_JAVA_TARGET_VERSION=8
      -DPYTHON_EXECUTABLE=#{which("python3.11")}
    ]

    # `lcm-lua/lualcm_lcm.c:577:9: error: ‘subscription’ may be used uninitialized`
    # See discussions in https://github.com/lcm-proj/lcm/issues/457
    ENV.append_to_cflags "-Wno-maybe-uninitialized" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"example_t.lcm").write <<~EOS
      package exlcm;
      struct example_t {
          int64_t timestamp;
          double position[3];
          string name;
      }
    EOS
    system bin/"lcm-gen", "-c", "example_t.lcm"
    assert_predicate testpath/"exlcm_example_t.h", :exist?, "lcm-gen did not generate C header file"
    assert_predicate testpath/"exlcm_example_t.c", :exist?, "lcm-gen did not generate C source file"
    system bin/"lcm-gen", "-x", "example_t.lcm"
    assert_predicate testpath/"exlcm/example_t.hpp", :exist?, "lcm-gen did not generate C++ header file"
    system bin/"lcm-gen", "-j", "example_t.lcm"
    assert_predicate testpath/"exlcm/example_t.java", :exist?, "lcm-gen did not generate Java source file"
    system bin/"lcm-gen", "-p", "example_t.lcm"
    assert_predicate testpath/"exlcm/example_t.py", :exist?, "lcm-gen did not generate Python source file"
  end
end
