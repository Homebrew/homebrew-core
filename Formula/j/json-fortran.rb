class JsonFortran < Formula
  desc "Fortran 2008 JSON API"
  homepage "https://github.com/jacobwilliams/json-fortran"
  url "https://github.com/jacobwilliams/json-fortran/archive/8.3.0.tar.gz"
  sha256 "5fe9ad709a726416cec986886503e0526419742e288c4e43f63c1c22026d1e8a"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/jacobwilliams/json-fortran.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d936676f2faf35b0341970dfb1061ce0aeb0f0614d86310106074449b784f93e"
    sha256 cellar: :any,                 arm64_monterey: "26b60a9213b96f66f52cb746e525b2d27f4bdcc32c8d5c45573a9bfe520cbe89"
    sha256 cellar: :any,                 arm64_big_sur:  "abb51e49f62492e8d97787aee78794d7cab70ac12bf87dd8b4fbdf800e6a2cfc"
    sha256 cellar: :any,                 ventura:        "ad02003294f9502cff6da74532bb2f70afe86a8f9c203cd5efbe46026a4176d0"
    sha256 cellar: :any,                 monterey:       "ac9ac273a706c8e39c67a27feb28a56afae3dd1e46102a31db6d9a64723377cc"
    sha256 cellar: :any,                 big_sur:        "9b6d905241a4d21fb09d2e247c9044b0f4cc3e02f616966191f2457503a3c61c"
    sha256 cellar: :any,                 catalina:       "e08acdb01ec8e436afe559000f89b82cb94600e6fabd31c18c0f39239e4e3bb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29d252bb182f924b58e988d72e565c022dc707b65022e837888c06d22cf6de6d"
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
