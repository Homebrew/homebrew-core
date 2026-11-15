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
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "a4b82373bd377999a9537419740b1b02dae0d88c347d0720a58c569921048b19"
    sha256 cellar: :any, arm64_tahoe:       "65b1c63c675361c7e252186707f76d727bb36d217d8706be82548f3b84fe7282"
    sha256 cellar: :any, arm64_sequoia:     "0e574aa5562e4abbc55678ff1115be182bdca2cb8404d470d6912e154e6efbcf"
    sha256 cellar: :any, arm64_linux:       "88ca6f6d4a040cd20e1f272d44fd59ee2cc626677be21905cfece13bd4bf99fb"
    sha256 cellar: :any, x86_64_linux:      "b76547e3157396c1cef0c177e6ee112f7d3b0ae0d17e4981bd3febd168f272aa"
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
