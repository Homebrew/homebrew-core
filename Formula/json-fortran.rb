class JsonFortran < Formula
  desc "Fortran 2008 JSON API"
  homepage "https://github.com/jacobwilliams/json-fortran"
  url "https://github.com/jacobwilliams/json-fortran/archive/8.2.3.tar.gz"
  sha256 "884ef4f955eecaf18d52e818738089ab3924981fb510ef3671ad3f62ac7c6af1"
  license "BSD-3-Clause"
  head "https://github.com/jacobwilliams/json-fortran.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "d1922f1d4ca2ebdbdc57fa37336c1a9497321362d2f4e78bada8a59c52e9858a"
    sha256 cellar: :any,                 big_sur:       "b4d52a6faa11cd988843aaad4ead3be45698ab96a8c8f47579d52fba976d8b3e"
    sha256 cellar: :any,                 catalina:      "e86c5acf2dd0cd6a8082d9129d5657c6e059df1367132094878164550c91c02d"
    sha256 cellar: :any,                 mojave:        "efded07e3332d3da9706f4c9172ecc611e9661a6a52084b234074627588ff9d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a18d2502328ce3f7e73e476208b7edd1513cdd14182799ba3852df11d1342afb"
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
