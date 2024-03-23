class Libobjc2 < Formula
  desc "Objective-C runtime library intended for use with Clang"
  homepage "https://github.com/gnustep/libobjc2"
  url "https://github.com/gnustep/libobjc2/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "768ea8c5bd0999a29b5d15781125494f986456c1dc5c51d370fb31852cd31ea1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7b71a49e26e6f376aea15f25c584ba70da3ea0c4cfbb7eaa0e66a52eb300ccb9"
  end

  depends_on "cmake" => :build
  # While libobjc2 is built with clang, it does not use any LLVM runtime libraries.
  depends_on "llvm" => [:build, :test]
  depends_on "pkg-config" => :test
  # Clang explicitly forbids building Mach-O binaries of libobjc2.
  # https://reviews.llvm.org/D46052
  # macOS provides an equivalent Objective-C runtime.
  depends_on :linux

  # Clang must be used on Linux because GCC Objective-C support is insufficient.
  fails_with :gcc

  resource "robin-map" do
    url "https://github.com/Tessil/robin-map/archive/refs/tags/v1.2.1.tar.gz"
    sha256 "2b54d2c1de2f73bea5c51d5dcbd64813a08caf1bfddcfdeee40ab74e9599e8e3"
  end

  def install
    (buildpath/"third_party/robin-map").install resource("robin-map")

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Change Objective-C header path which assumes tests are being run in source tree.
    inreplace ["Test/Test.h", "Test/Test.m"], "../objc", "objc"
    pkgshare.install "Test"
  end

  test do
    # ENV.cc returns llvm_clang, which does not work in a test block.
    ENV["CC"] = Formula["llvm"].opt_bin/"clang"

    # Copy over test library and header and runtime test.
    cp pkgshare/"Test/Test.h", testpath
    cp pkgshare/"Test/Test.m", testpath
    cp pkgshare/"Test/RuntimeTest.m", testpath

    # First build test shared library and then link it to RuntimeTest.
    pkg_config_flags = Utils.safe_popen_read("pkg-config", "--cflags", "--libs", "libobjc").chomp.split
    system ENV.cc, "Test.m", "-fobjc-runtime=gnustep-2.0", *pkg_config_flags,
                   "-fPIC", "-shared", "-o", "libTest.so"
    system ENV.cc, "RuntimeTest.m", "-fobjc-runtime=gnustep-2.0", *pkg_config_flags, "-Wl,-rpath,#{lib}",
                   "-L#{testpath}", "-Wl,-rpath,#{testpath}", "-lTest", "-o", "RuntimeTest"

    # RuntimeTest deliberately throws a test exception and outputs this to stderr.
    assert_match "testExceptions() ran", shell_output("#{testpath}/RuntimeTest 2>&1")
  end
end
