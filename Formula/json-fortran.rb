class JsonFortran < Formula
  desc "Fortran 2008 JSON API"
  homepage "https://github.com/jacobwilliams/json-fortran"
  url "https://github.com/jacobwilliams/json-fortran/archive/6.10.0.tar.gz"
  sha256 "8a383e454b39c821e2f53c6aea2a5390a3bcc12949c9d289780ab11dc081302a"
  head "https://github.com/jacobwilliams/json-fortran.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "021c8eabf2aee746ed943ffc7b2c04f75443c0ecc02c204912d5eb53e7dde92b" => :mojave
    sha256 "5d52dd19f542e22a60d832b43d5d45d25c01b5a0833e029f5a42fcf4cf397e47" => :high_sierra
    sha256 "6878d6ffaf0c77bf27948db9699cb12c4b2a7f8a1494396f0b1f02f889bea297" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "ford" => :build
  depends_on "gcc" # for gfortran

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DUSE_GNU_INSTALL_CONVENTION:BOOL=TRUE",
                            "-DENABLE_UNICODE:BOOL=TRUE"
      system "make", "install"
    end
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
