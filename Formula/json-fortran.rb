class JsonFortran < Formula
  desc "Fortran 2008 JSON API"
  homepage "https://github.com/jacobwilliams/json-fortran"
  url "https://github.com/jacobwilliams/json-fortran/archive/8.0.0.tar.gz"
  sha256 "2c9c62117a2548e2cddf55acf7b726b529c044ed0f1eefe14dc69910a54a7bfd"
  head "https://github.com/jacobwilliams/json-fortran.git"

  bottle do
    cellar :any
    sha256 "6c78e3ce735562f37b3f37a6d69363fdc75ffaf86f4d77a216b0aa49a9ac02a0" => :catalina
    sha256 "cb39426c08042ad364fac5a0d33dbfb3fa1aaf1cb4dbfca588f55c1377682482" => :mojave
    sha256 "2f485777f4d42f9efc26e04d5e9e5022dd125a98fae3836e68c2cc4dd380ee2a" => :high_sierra
    sha256 "02426bf82ef55161c1b698fa68d455f35705bad09e04b07586d8ed9f44775f90" => :sierra
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
