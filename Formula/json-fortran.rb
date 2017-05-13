class JsonFortran < Formula
  desc "Fortran 2008 JSON API"
  homepage "https://github.com/jacobwilliams/json-fortran"
  url "https://github.com/jacobwilliams/json-fortran/archive/5.3.0.tar.gz"
  sha256 "1e85796c0b4e0a6f08c1b49d1b46d30609d0bed630741b02ea83b4be9bf61c62"
  revision 1
  head "https://github.com/jacobwilliams/json-fortran.git"

  bottle do
    cellar :any
    sha256 "43d9f91632a29ef2e3850674723551ad26c2edac8c3d64285eb3ec74b24f2ba7" => :sierra
    sha256 "28e62106c41ce31441ae6134ffdebbfd34076bdf0c03feee76ec77822e35a8a8" => :el_capitan
    sha256 "9ee24ad05916879ba34a8c96cc6554355a2803c1ed5cffa46f37eec91ec44fc1" => :yosemite
  end

  option "with-unicode-support", "Build json-fortran to support unicode text in json objects and files"
  option "without-test", "Skip running build-time tests (not recommended)"
  option "without-docs", "Do not build and install FORD generated documentation for json-fortran"

  deprecated_option "without-robodoc" => "without-docs"

  depends_on "ford" => :build if build.with? "docs"
  depends_on "cmake" => :build
  depends_on :fortran

  def install
    mkdir "build" do
      args = std_cmake_args
      args << "-DUSE_GNU_INSTALL_CONVENTION:BOOL=TRUE" # Use more GNU/Homebrew-like install layout
      args << "-DENABLE_UNICODE:BOOL=TRUE" if build.with? "unicode-support"
      args << "-DSKIP_DOC_GEN:BOOL=TRUE" if build.without? "docs"
      system "cmake", "..", *args
      system "make", "check" if build.with? "test"
      system "make", "install"
    end
  end

  test do
    ENV.fortran
    (testpath/"json_test.f90").write <<-EOS.undent
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
    system ENV.fc, "-ojson_test", "-ljsonfortran", "-I#{HOMEBREW_PREFIX}/include", testpath/"json_test.f90"
    system "./json_test"
  end
end
