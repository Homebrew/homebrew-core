class JsonFortran < Formula
  desc "Fortran 2008 JSON API"
  homepage "https://github.com/jacobwilliams/json-fortran"
  url "https://github.com/jacobwilliams/json-fortran/archive/refs/tags/8.4.0.tar.gz"
  sha256 "71924c3bdd04ea37ddceb13c1b9e1e4a8f944b1ffab6285e5c5b1283cced2da8"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/jacobwilliams/json-fortran.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f87ad5e09e1810b7b512b5ff9bc196a921c4cd81487c7cfc1cdd5b65b75235b2"
    sha256 cellar: :any,                 arm64_ventura:  "aa20f4e550e3ed396313d7b20ccbd4ccb878f274a9d399c158ba36cdd679eaa0"
    sha256 cellar: :any,                 arm64_monterey: "5483930c77d4407f7e26b8516eb6a00d0da926e39087697263e1944f9b853250"
    sha256 cellar: :any,                 sonoma:         "212aeec6c9ea40ee64f3ac6659e52e644e56b6385889c138970c055d40bf1baf"
    sha256 cellar: :any,                 ventura:        "a1a99cc2f55e8dfb6d6eb76c12623a9a3a0718a2cfdf7c099c78e914104b483c"
    sha256 cellar: :any,                 monterey:       "4f21d27d78c618378d79e38c6f37631476c7633e7cbb1b598acab9e5b6ad1148"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afca49a1aa95a4ed00163fd07cafbcb9a0d5a72de717a76d3d04733f78823f7a"
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
