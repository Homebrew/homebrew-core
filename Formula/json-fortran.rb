class JsonFortran < Formula
  desc "Fortran 2008 JSON API"
  homepage "https://github.com/jacobwilliams/json-fortran"
  url "https://github.com/jacobwilliams/json-fortran/archive/8.3.0.tar.gz"
  sha256 "5fe9ad709a726416cec986886503e0526419742e288c4e43f63c1c22026d1e8a"
  license "BSD-3-Clause"
  head "https://github.com/jacobwilliams/json-fortran.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "69bc64f257e0822b4d02ebf60214be91b34d5df46c4f7c5f39265853321ed100"
    sha256 cellar: :any,                 arm64_big_sur:  "ff444851e376c1fa73c5ee74bb42eb8dd2b9c4b0f5bb91e2851537f509fd1867"
    sha256 cellar: :any,                 monterey:       "292c1430dded110719d5f22a3589861b04360ef2f939178654a52938c2ce6644"
    sha256 cellar: :any,                 big_sur:        "8e2eb0c4b30b851713fc0b0d3ea2499515c13dfb62df8e885f8530ee1999c060"
    sha256 cellar: :any,                 catalina:       "92dbd2d11bdc588ff5044f2fa55ce77ae009e4749648068cbb3a8467c8692476"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d0299f6ba3e940f86741f6c2d4491d14134d90048650d3c445c18f61f79014c"
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
