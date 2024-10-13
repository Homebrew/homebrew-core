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
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "3bc6bba97d622e6cad92654b13a189117a05b102d9dff87714692129f010ef80"
    sha256 cellar: :any,                 arm64_sonoma:  "2d24850362c0287ebb15776799bf023a6eb05baed1ebbede56a12b7c2391920a"
    sha256 cellar: :any,                 arm64_ventura: "1589412c5fd3789d077c01981f4c8ef633aea1a2f06448a27b75e4e41e01de3f"
    sha256 cellar: :any,                 sonoma:        "e965eaa67eaabbfab0cbfcfe4850fb604e436ba8542421f93be5e3013004736d"
    sha256 cellar: :any,                 ventura:       "b5c5f4ac2c858419c931f30903a7cd07a0d6bceb9740a17d5fc156a58b82280c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18c704832fce5312938ebef41001b435a111a8a12441837fd2f82d9cc5e0db6c"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "lua"
  depends_on "openjdk"
  depends_on "python@3.13"

  def python3
    which("python3.13")
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
