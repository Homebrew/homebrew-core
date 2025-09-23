class Lcm < Formula
  desc "Libraries and tools for message passing and data marshalling"
  homepage "https://lcm-proj.github.io/"
  url "https://github.com/lcm-proj/lcm/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "40ba0b7fb7c9ad06d05e06b4787d743cf11be30eb4f1a03abf4a92641c5b1203"
  license "LGPL-2.1-or-later"
  head "https://github.com/lcm-proj/lcm.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "1dcec315bc99d85506a8882e39e17283165a800cbd22a3bcc643bf404961b396"
    sha256 cellar: :any,                 arm64_sequoia: "cd5794313c2136f837cc4235fedc5bcb6dfa1300cc3a5d9524a0346c1e91bd97"
    sha256 cellar: :any,                 arm64_sonoma:  "adb6c73895ff02cd561aea543e2fbd756d7aa2205237dbad6138c4516c34d6ad"
    sha256 cellar: :any,                 arm64_ventura: "000805ebd7cd74df1f20575e964a84a1e671c110861a0c94e09a47b417cf2818"
    sha256 cellar: :any,                 sonoma:        "3caf4d4ac4e480add5a3b74601a7be8d6c7d9f455eb2ddfede706614e30ded77"
    sha256 cellar: :any,                 ventura:       "231e26c5826e2ae3f6c5cf0725d45f21e7a49a88a39f5a3bcc8f058003d185b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee71ab26af0ccabb7cd2a7b6648d9307293e6e72af5b061312cd49a7ea6c1375"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a73f26e38bef338372062dbc93ac8d69bd1fc27fe6df22e7d67c05d0cbc97023"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "lua"
  depends_on "openjdk"
  depends_on "python@3.13"

  def python3
    which("python3.13")
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
