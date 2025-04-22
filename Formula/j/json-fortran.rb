class JsonFortran < Formula
  desc "Fortran 2008 JSON API"
  homepage "https://github.com/jacobwilliams/json-fortran"
  url "https://github.com/jacobwilliams/json-fortran/archive/refs/tags/9.0.3.tar.gz"
  sha256 "ea6e02ab4873d43e2059d51d8392422d6f746a7a9ea0fb18ab28a3beb4fef13c"
  license "BSD-3-Clause"
  head "https://github.com/jacobwilliams/json-fortran.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "431800da5e3125fabc45e0694e5f038427c5730e7819c8172979aa30208f03ee"
    sha256 cellar: :any,                 arm64_sonoma:  "fda27b3d2119ec2f4b33851c3ea7df66ee9d40ee60db229f9f8131eb33bc0fa9"
    sha256 cellar: :any,                 arm64_ventura: "a5f19471c0343e161e383982b38652b099e3a1bd6c334b305f8965d4e87cc582"
    sha256 cellar: :any,                 sonoma:        "d8a62d6d7cd520d8d614d097ddb33611a7d234874733a93ee7f5c143fe7f3c09"
    sha256 cellar: :any,                 ventura:       "414fd1579e8b0a005d62dc650f733b96459003989144813942154091b506a41a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "909feb913cf7a36c8ab7c4c10243e5f5a8500c57ba6ccf519fad0f8dc1561391"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b0f3c60aa5ce457a0bd8775db131a05d97ea280219cb5012408cf4bb2703250"
  end

  depends_on "cmake" => :build
  depends_on "ford" => :build
  depends_on "gcc" # for gfortran

  def install
    args = %w[
      -DUSE_GNU_INSTALL_CONVENTION:BOOL=TRUE
      -DENABLE_UNICODE:BOOL=TRUE
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"json_test.f90").write <<~FORTRAN
      program example
      use json_module, RK => json_RK
      use iso_fortran_env, only: stdout => output_unit
      implicit none
      type(json_core) :: json
      type(json_value),pointer :: p, inp
      call json%initialize()
      call json%create_object(p,'')
      call json%create_object(inp,'inputs')
      call json%add(p, inp)
      call json%add(inp, 't0', 0.1_RK)
      call json%print(p,stdout)
      call json%destroy(p)
      if (json%failed()) error stop 'error'
      end program example
    FORTRAN
    system "gfortran", "-o", "test", "json_test.f90", "-I#{include}",
                       "-L#{lib}", "-ljsonfortran"
    system "./test"
  end
end
