class Lcm < Formula
  desc "Libraries and tools for message passing and data marshalling"
  homepage "https://lcm-proj.github.io/"
  url "https://github.com/lcm-proj/lcm/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "d443261619080f1c0693237b2019436988e1b2b2ba5fc09a49bf23769e1796de"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/lcm-proj/lcm.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "67786ac0f37fa1fd51a11d36eac2c7a15e8d9374f3bf402539455cab4a04e3d4"
    sha256 cellar: :any,                 arm64_sequoia: "44b5288a4c51bf6c703cdeb518934b993ef424593590b12247cb51da83df8daf"
    sha256 cellar: :any,                 arm64_sonoma:  "3c098c947859fa7af78056c13507cdb50f6da1fe5a66c3d1ef5e2bac26e5dfbb"
    sha256 cellar: :any,                 sonoma:        "0538d2bfe93470a2d9faf159a225adf8ec196f79f54af777236996341ad1aec8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2f6a5cc8b26cc546f7c02c6004f7309dcfeb4d8fbbfacd40fa29b4e766b19bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7867fc41099802b39b1ffcb7c70733c7d0dd99f22bbd0a719bb26ecde5ebb93"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "lua"
  depends_on "openjdk"
  depends_on "python@3.14"

  def python3
    which("python3.14")
  end

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
