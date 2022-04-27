class Halide < Formula
  desc "Language for fast, portable data-parallel computation"
  homepage "https://halide-lang.org"
  url "https://github.com/halide/Halide/archive/v14.0.0.tar.gz"
  sha256 "f9fc9765217cbd10e3a3e3883a60fc8f2dbbeaac634b45c789577a8a87999a01"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5d6deeee63f5251f982a8bd33b5eadde2ed76043243d2b0b3549a5d73d40773b"
    sha256 cellar: :any,                 arm64_big_sur:  "2a3a60f4bf9e2b96e060ccd3f97bdb5f01300db7d41064a1f8ea5522eaae6fe5"
    sha256 cellar: :any,                 monterey:       "6c76d4bda2ecde2563febab79f1b56a9d2f3f42f30359974875ebd5ee46a9978"
    sha256 cellar: :any,                 big_sur:        "cb88aa6cb18664d402c9bc329ec8eaec11e42e0ccc2cb6d9831411cd5e730d7e"
    sha256 cellar: :any,                 catalina:       "5cfc526ab5d5bb5c7e24ec6f5cd67679d4ad7820d8834c55b1b1b655c2ec5320"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f60867f23283b511e17b91c4f6cdcb0cf17e98026bc86afa21a9e22aed92b5bf"
  end

  depends_on "cmake" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "llvm"
  depends_on "python@3.10"

  fails_with gcc: "5" # LLVM is built with Homebrew GCC

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}", "-DHalide_SHARED_LLVM=ON"
      system "make"
      system "make", "install"
    end
  end

  test do
    cp share/"doc/Halide/tutorial/lesson_01_basics.cpp", testpath
    system ENV.cxx, "-std=c++17", "lesson_01_basics.cpp", "-L#{lib}", "-lHalide", "-o", "test"
    assert_match "Success!", shell_output("./test")
  end
end
