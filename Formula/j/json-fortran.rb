class JsonFortran < Formula
  desc "Fortran 2008 JSON API"
  homepage "https://github.com/jacobwilliams/json-fortran"
  url "https://github.com/jacobwilliams/json-fortran/archive/refs/tags/9.0.2.tar.gz"
  sha256 "a599a77e406e59cdb7672d780e69156b6ce57cb8ce515d21d1744c4065a85976"
  license "BSD-3-Clause"
  head "https://github.com/jacobwilliams/json-fortran.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "8ffb42ea8a194a6029d0ad47bd3d4bae4adbdf8f0b14726af48afd7fc6343963"
    sha256 cellar: :any,                 arm64_sonoma:   "5e034a7f658d0ff3da94c19e60ec9ddaf77d51ae9ac42f66dfa9901e598877ea"
    sha256 cellar: :any,                 arm64_ventura:  "4f598bd25a89c0083106c0064fd8c0ea39ef1986e92d0eb11dffe277b28d9dab"
    sha256 cellar: :any,                 arm64_monterey: "1aecb3d0ca1917d36097e193c3341df8443c8e069cdd190cb2a097bc5132e715"
    sha256 cellar: :any,                 sonoma:         "3e6a8204ff675886107d82f1e175ed4c67472a964d9aad4cb9e5bb08beb8702b"
    sha256 cellar: :any,                 ventura:        "161aa3a9eaa9563dba768fdefa281950875746784ac4793264b524a57f012fb3"
    sha256 cellar: :any,                 monterey:       "575e8d419b6d12e6cc57d7081b947d8c40ca346321f5443c647160ecbcb02ba3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d86458d665027a9eefc14813ce813d6e056ca431532a5b929ad1deabcd93eaca"
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
    (testpath/"json_test.f90").write <<~EOS
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
    EOS
    system "gfortran", "-o", "test", "json_test.f90", "-I#{include}",
                       "-L#{lib}", "-ljsonfortran"
    system "./test"
  end
end
