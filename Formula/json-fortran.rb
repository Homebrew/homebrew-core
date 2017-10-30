class JsonFortran < Formula
  desc "Fortran 2008 JSON API"
  homepage "https://github.com/jacobwilliams/json-fortran"
  url "https://github.com/jacobwilliams/json-fortran/archive/6.0.0.tar.gz"
  sha256 "fecdde3b4c763bb667bdb3becb3a06661a39005a9f9b7d5e015e18e9768ddea8"
  head "https://github.com/jacobwilliams/json-fortran.git"

  bottle do
    cellar :any
    sha256 "25db1fa8724ca91199e3b92586465eb5dd809e1a1f337f0e081b390505ab1bca" => :high_sierra
    sha256 "4cd52f0d99f0a0d3669ecf6d251933afbc4a304ec1a5684a519e0f5ead73dd84" => :sierra
    sha256 "3c82864128f7d4aa61878c2a7d0044a4cd3f506391fe31186b4e696e91b49c17" => :el_capitan
    sha256 "15e3580c6f75be9e566591a3095acf6d73d1fe457b0d07bcb43875968511770a" => :yosemite
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
    system ENV.fc, "-ojson_test", "-ljsonfortran", "-I#{HOMEBREW_PREFIX}/include", testpath/"json_test.f90"
    system "./json_test"
  end
end
