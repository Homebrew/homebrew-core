class JsonFortran < Formula
  desc "Fortran 2008 JSON API"
  homepage "https://github.com/jacobwilliams/json-fortran"
  url "https://github.com/jacobwilliams/json-fortran/archive/6.9.0.tar.gz"
  sha256 "bf19159372f580eab12e711fef8ac637624d32766dd3c30534007d1b4091f092"
  head "https://github.com/jacobwilliams/json-fortran.git"

  bottle do
    cellar :any
    sha256 "85e707fd570aa82ea2a778672d7acd0cb7e57b005ffa1af9c813ea97a134dfdd" => :high_sierra
    sha256 "756cabef5356fce1afb3d73f4341e5e78a3215003d44b2cb61aeb0fd479616d6" => :sierra
    sha256 "2627d98d477770aacb37f0f8d3a8d5edfe10020c6dfa43ae97be94402dbb562c" => :el_capitan
  end

  option "with-unicode-support", "Build json-fortran to support unicode text in json objects and files"
  option "without-docs", "Do not build and install FORD generated documentation for json-fortran"

  deprecated_option "without-robodoc" => "without-docs"

  depends_on "cmake" => :build
  depends_on "ford" => :build if build.with? "docs"
  depends_on "gcc" # for gfortran

  def install
    mkdir "build" do
      args = std_cmake_args
      args << "-DUSE_GNU_INSTALL_CONVENTION:BOOL=TRUE" # Use more GNU/Homebrew-like install layout
      args << "-DENABLE_UNICODE:BOOL=TRUE" if build.with? "unicode-support"
      args << "-DSKIP_DOC_GEN:BOOL=TRUE" if build.without? "docs"
      system "cmake", "..", *args
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
