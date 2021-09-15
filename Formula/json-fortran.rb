class JsonFortran < Formula
  desc "Fortran 2008 JSON API"
  homepage "https://github.com/jacobwilliams/json-fortran"
  url "https://github.com/jacobwilliams/json-fortran/archive/8.2.5.tar.gz"
  sha256 "16eec827f64340c226ba9a8463f001901d469bc400a1e88b849f258f9ef0d100"
  license "BSD-3-Clause"
  head "https://github.com/jacobwilliams/json-fortran.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "3b5514eebeaab114f4d15eaecf38801243dbf459678dca3e34abde711fb9d464"
    sha256 cellar: :any,                 big_sur:       "5f0d95474e94df306b48cb3efa41faf3063bded45b35bb115d2b9b5c14f76ca5"
    sha256 cellar: :any,                 catalina:      "02437f7df43e2615343b61de2cdffbca011a43ea578cdd9ca4c41205c687947c"
    sha256 cellar: :any,                 mojave:        "e09a2b0652b503775d930080bf6a9abc960b2c937e424543450d1977fcdd9ae0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f851ba973758580382272905235a3e4360dcf3a80027730d4800a5863b7085d8"
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
