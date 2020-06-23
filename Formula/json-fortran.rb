class JsonFortran < Formula
  desc "Fortran 2008 JSON API"
  homepage "https://github.com/jacobwilliams/json-fortran"
  url "https://github.com/jacobwilliams/json-fortran/archive/8.1.0.tar.gz"
  sha256 "4f4b3bf102d7e22327b0e4b8a3cadd8c3e453c969547ec21cd2429ed7d4c5404"
  head "https://github.com/jacobwilliams/json-fortran.git"

  bottle do
    cellar :any
    sha256 "b91a5fdd1177c829ac6e0367aa1caae9ad562ddfc397942dfeebbb672c73bb59" => :catalina
    sha256 "e2b423de03ec31026e8eea2ddc2a90f561008cb447a0df3051443978bb30913c" => :mojave
    sha256 "8312ecd04aab73a6f7783d0247aa7dd2697052991c466ac1d5306d482aea8010" => :high_sierra
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
