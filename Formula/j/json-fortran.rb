class JsonFortran < Formula
  desc "Fortran 2008 JSON API"
  homepage "https://github.com/jacobwilliams/json-fortran"
  url "https://github.com/jacobwilliams/json-fortran/archive/refs/tags/8.4.0.tar.gz"
  sha256 "71924c3bdd04ea37ddceb13c1b9e1e4a8f944b1ffab6285e5c5b1283cced2da8"
  license "BSD-3-Clause"
  head "https://github.com/jacobwilliams/json-fortran.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e4ad43af9fd365bdeeb64ad04cee256d7a6a4f6645df5aac4f2e4aedd3baa756"
    sha256 cellar: :any,                 arm64_ventura:  "22a2596fbd14f95614ebe5b8fb7fbfa5f24d7b8713ebba25a13eca170c329cf2"
    sha256 cellar: :any,                 arm64_monterey: "59da8ac4eb97345f2cc46790fb035cbf23bc96a4e04fa8d174d49268fa903c09"
    sha256 cellar: :any,                 sonoma:         "c76e899cf2d5d81b0a7b9c87834338facd66e7bad56f693df598b9d6eae16429"
    sha256 cellar: :any,                 ventura:        "484edba0b77d708bd4a1c208d60d738294838d5d3945be9a3b1d3fd31b28024d"
    sha256 cellar: :any,                 monterey:       "98ff7ecf570b1d9cdeb654f79cbceece917ce2f1b70d29455db2e0b571d9e4cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88a2bdfb8e1a166a1abfcd963c511d679c553e503417e86898fd79768ba7473c"
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
