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
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "5d1db2950892b7453af6ef86c81e4ac03cd6b91f71b398c10d6848e5683339b7"
    sha256 cellar: :any,                 arm64_ventura:  "4a809af57394e0379df764778977115dc8b8cf6d6c5f6898d95797012a7b4924"
    sha256 cellar: :any,                 arm64_monterey: "f5afc343736b2f84e48b3d365a9424bf306fa1b0e72b70da628c7735eb90b7dd"
    sha256 cellar: :any,                 sonoma:         "1d2f9816f32cb37046939805b19f143a86ef70fa4f9b6f9c46a9fbacb14b5120"
    sha256 cellar: :any,                 ventura:        "cb6bb58d21d57f335f8bd021c021939b46f82050a05d56cca3c5642aef1650c3"
    sha256 cellar: :any,                 monterey:       "fdf7d422eb1ccbe7a152dc3a1973913114eba7e2176f9c3aeb5de7511ad8fd74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "276ec5165d97b216b53c9056674e853fc85f4e5420811cb034412591c746ba9a"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "lua"
  depends_on "openjdk"
  depends_on "python@3.12"

  def python3
    which("python3.12")
  end

  def install
    # Adding RPATH in #{lib}/lua/X.Y/lcm.so and some #{bin}/*.
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{lib}
      -DLCM_ENABLE_EXAMPLES=OFF
      -DLCM_ENABLE_TESTS=OFF
      -DLCM_JAVA_TARGET_VERSION=8
      -DPYTHON_EXECUTABLE=#{python3}
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
