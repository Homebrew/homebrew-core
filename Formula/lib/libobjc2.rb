class Libobjc2 < Formula
  desc "Objective-C runtime library intended for use with Clang"
  homepage "https://github.com/gnustep/libobjc2"
  url "https://github.com/gnustep/libobjc2/archive/refs/tags/v2.3.tar.gz"
  sha256 "5ead2276b42a534ac40437ce53b2231320b985539dc325453d93874be8d92869"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "f3555edab456c1bc62c1d549893f3bf913382b7e3b8ab56b367d3d3d4ce212b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c6d20fc9b954bab4b841f4249bf92440214685726aa61033b866791898b4e8d1"
  end

  depends_on "cmake" => :build
  # While libobjc2 is built with clang, it does not use any LLVM runtime libraries.
  depends_on "llvm" => [:build, :test]
  depends_on "robin-map" => :build
  depends_on "pkgconf" => :test
  # Clang explicitly forbids building Mach-O binaries of libobjc2.
  # https://reviews.llvm.org/D46052
  # macOS provides an equivalent Objective-C runtime.
  depends_on :linux

  # Clang must be used on Linux because GCC Objective-C support is insufficient.
  fails_with :gcc

  def install
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
    flags = shell_output("pkgconf --cflags --libs libobjc").chomp.split
    system ENV.cc, "Test.m", "-fobjc-runtime=gnustep-2.0", *flags,
                   "-fPIC", "-shared", "-o", "libTest.so"
    system ENV.cc, "RuntimeTest.m", "-fobjc-runtime=gnustep-2.0", *flags, "-Wl,-rpath,#{lib}",
                   "-L#{testpath}", "-Wl,-rpath,#{testpath}", "-lTest", "-o", "RuntimeTest"

    # RuntimeTest deliberately throws a test exception and outputs this to stderr.
    assert_match "testExceptions() ran", shell_output("./RuntimeTest 2>&1")
  end
end
