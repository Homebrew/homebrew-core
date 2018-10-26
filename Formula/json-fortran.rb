class JsonFortran < Formula
  desc "Fortran 2008 JSON API"
  homepage "https://github.com/jacobwilliams/json-fortran"
  url "https://github.com/jacobwilliams/json-fortran/archive/6.10.0.tar.gz"
  sha256 "8a383e454b39c821e2f53c6aea2a5390a3bcc12949c9d289780ab11dc081302a"
  head "https://github.com/jacobwilliams/json-fortran.git"

  bottle do
    cellar :any
    sha256 "f98191c2916fde89d4ab0f519c68503363f89e26ac3bd4ffe5ca3f8c7847ade8" => :mojave
    sha256 "a44bc978afd9ce07c610ed63dcd9e5dea7a070a5bc225be412f5a6046f0e2df2" => :high_sierra
    sha256 "27eeca7326c6348a816d0804cc720da5c3ed15e611a23e6666059e175f09af37" => :sierra
  end

  option "with-unicode-support", "Build json-fortran to support unicode text in json objects and files"

  depends_on "cmake" => :build
  depends_on "ford" => :build
  depends_on "gcc" # for gfortran

  def install
    mkdir "build" do
      args = std_cmake_args
      args << "-DUSE_GNU_INSTALL_CONVENTION:BOOL=TRUE" # Use more GNU/Homebrew-like install layout
      args << "-DENABLE_UNICODE:BOOL=TRUE" if build.with? "unicode-support"
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
