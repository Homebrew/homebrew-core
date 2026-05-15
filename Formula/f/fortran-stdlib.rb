class FortranStdlib < Formula
  desc "Fortran Standard Library"
  homepage "https://stdlib.fortran-lang.org"
  url "https://github.com/fortran-lang/stdlib/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "6d20b120a4b17fb23ee5353408f6826b521bd006cd42eb412b01984eb9c31ded"
  license "MIT"
  head "https://github.com/fortran-lang/stdlib.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "019e3842f56d2193a7db71556efd8e93bdafe4defceea47da9ced6230444546e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab2688d5cd5a9b0c2fd3e2cbfc6cd0a6d717f8d247823433140d661f3aec0f6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a7973a27887a0347b6d82cd570bfbfd3e2fca833df30def20003ec665dec3cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "50ec9b4f641125459e9193afc056d479655502d8704267dd6bcf41a745690ff9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c25d5ce02e32da1a0e8a30c2bfcefb846244ffb5454c2f727394a0522336df5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00fa8e5b2da7e2e4e4f35962f605f4692d30e0dd964e82f43c3f2436d9486b20"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "fypp" => :build
  depends_on "gcc" # for gfortran

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "example"
  end

  test do
    cp pkgshare/"example/version/example_version.f90", testpath

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.14)
      project(test LANGUAGES Fortran)

      find_package(BLAS)
      find_package(LAPACK)
      find_package(fortran_stdlib REQUIRED)

      add_executable(test example_version.f90)
      target_link_libraries(test PRIVATE fortran_stdlib::fortran_stdlib)
    CMAKE

    system "cmake", "-S", "."
    system "cmake", "--build", "."
    system "./test"
  end
end
