class Lcm < Formula
  desc "Libraries and tools for message passing and data marshalling"
  homepage "https://lcm-proj.github.io/"
  url "https://github.com/lcm-proj/lcm/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "d443261619080f1c0693237b2019436988e1b2b2ba5fc09a49bf23769e1796de"
  license "LGPL-2.1-or-later"
  head "https://github.com/lcm-proj/lcm.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a0820b5805c1dc9787283af4bd977504bc3431fa6e7685a21e1778478b231bf8"
    sha256 cellar: :any,                 arm64_sequoia: "350e2c304a9436ef574780ade663d065799462371d33fda7d130c364f1c65e90"
    sha256 cellar: :any,                 arm64_sonoma:  "8189eb0848a56d7387dd4b722d068caa11b830495db510be29b559e481e58e2b"
    sha256 cellar: :any,                 sonoma:        "6a23eae035e3467c83d90580e1dd30eb88272a504ef60016d49fe805340de6a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7cf043230b6efeca9f96c6bfc076905ccb20227408bd5a88490b7dc9ebf9eb23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f2d9a79b688298ec1f01703856bf0a70e2cbf74793aea29b754b546a698df6c"
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
