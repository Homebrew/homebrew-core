class Lcm < Formula
  desc "Libraries and tools for message passing and data marshalling"
  homepage "https://lcm-proj.github.io/"
  url "https://github.com/lcm-proj/lcm/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "f7e693d50e229e37de00387ac8ab9228e16559dd57bddd155c4b5ca1c233834e"
  license "LGPL-2.1-or-later"
  head "https://github.com/lcm-proj/lcm.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f252d68ed3ba4e280f83de644253f3daef3897ad6aae5d2207f010439dbfc1f2"
    sha256 cellar: :any, arm64_tahoe:       "081b13339dca7511d79e77cc3f7e0f27d96870e01b6ebfef22a12e674f417660"
    sha256 cellar: :any, arm64_sequoia:     "1b7cd49fd99ee488e7870c564d90ebdb4da6f53da539927a05c5c98eadfe6672"
    sha256 cellar: :any, arm64_linux:       "7d29b026b5a82f7cc10c929aebf892544ee9f11c155df1964d6a076dbe209371"
    sha256 cellar: :any, x86_64_linux:      "71208d791519e0c36b5e32b82813ea4556399469428ac56fcbfc33dd505a5b30"
  end

  depends_on "cmake" => :build

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "lua"
  depends_on "openjdk"
  depends_on "python@3.15"

  deny_network_access!
  def install
    # Adding RPATH in #{lib}/lua/X.Y/lcm.so and some #{bin}/*.
    lua_lib = lib/"lua"/Formula["lua"].version.major_minor
    lcm_site_packages = prefix/Language::Python.site_packages("python3")/"lcm"
    rpaths = [rpath, rpath(source: lua_lib), rpath(source: lcm_site_packages)]

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}
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
    assert_path_exists testpath/"exlcm_example_t.h", "lcm-gen did not generate C header file"
    assert_path_exists testpath/"exlcm_example_t.c", "lcm-gen did not generate C source file"
    system bin/"lcm-gen", "-x", "example_t.lcm"
    assert_path_exists testpath/"exlcm/example_t.hpp", "lcm-gen did not generate C++ header file"
    system bin/"lcm-gen", "-j", "example_t.lcm"
    assert_path_exists testpath/"exlcm/example_t.java", "lcm-gen did not generate Java source file"
    system bin/"lcm-gen", "-p", "example_t.lcm"
    assert_path_exists testpath/"exlcm/example_t.py", "lcm-gen did not generate Python source file"
  end
end
