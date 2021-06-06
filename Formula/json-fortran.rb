class JsonFortran < Formula
  desc "Fortran 2008 JSON API"
  homepage "https://github.com/jacobwilliams/json-fortran"
  url "https://github.com/jacobwilliams/json-fortran/archive/8.2.3.tar.gz"
  sha256 "884ef4f955eecaf18d52e818738089ab3924981fb510ef3671ad3f62ac7c6af1"
  license "BSD-3-Clause"
  head "https://github.com/jacobwilliams/json-fortran.git"

  bottle do
    sha256               arm64_big_sur: "db49244c3e34e2aa3d854f07bbaa36f0bd35d6c07227f85a637ee5415f195f45"
    sha256 cellar: :any, big_sur:       "092da7278fc5dce280f8be6bc4a8604f8f73e2d87a41f44fd31669b7d06f805f"
    sha256 cellar: :any, catalina:      "5f367f5e06aea2b898dc4de833c5576660439912ff8f87248be58e9b7b1900b9"
    sha256 cellar: :any, mojave:        "62d4b07c14b63e49554d4e8594a1939ac6541811dac45208e36074cce7253d38"
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
