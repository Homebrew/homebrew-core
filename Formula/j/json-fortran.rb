class JsonFortran < Formula
  desc "Fortran 2008 JSON API"
  homepage "https://github.com/jacobwilliams/json-fortran"
  url "https://github.com/jacobwilliams/json-fortran/archive/refs/tags/9.3.1.tar.gz"
  sha256 "301a8d205bc7510b21c731130c30babd552c33e3f20568ce732b5e165b1f7a86"
  license "BSD-3-Clause"
  head "https://github.com/jacobwilliams/json-fortran.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0bfbf56faa41240ada69ead84c20f1e006c1515fffa7836f78a6e742b9bfc026"
    sha256 cellar: :any,                 arm64_sequoia: "e96de8e36a76969b8113dbbe77459698ddbb49fe0ea892a2ad37c6fefa3b5bfe"
    sha256 cellar: :any,                 arm64_sonoma:  "eaba5780f22a68e2fa8e106ebfe7363cc7c7debc33388c7cd2a7e1f43b983dfc"
    sha256 cellar: :any,                 sonoma:        "f9d4bb1fdd94e6fca2b385edfbd9ef405e32b164758d92ce962acf16969c45b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc25a87494b26cfe74b3d2d731d318ec0e1bd7251f66751c4b3414f632aab67e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "444ca14a92e02ef5527fea110463c6ef368888ee96ac353ba4ce903eddd6ac0c"
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
    ENV.prepend_path "PATH", Formula["binutils"].opt_bin if OS.linux?
    system "gfortran", "-o", "test", "json_test.f90", "-I#{include}",
                       "-L#{lib}", "-ljsonfortran"
    system "./test"
  end
end
