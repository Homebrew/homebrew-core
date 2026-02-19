class JsonFortran < Formula
  desc "Fortran 2008 JSON API"
  homepage "https://github.com/jacobwilliams/json-fortran"
  url "https://github.com/jacobwilliams/json-fortran/archive/refs/tags/9.2.0.tar.gz"
  sha256 "74317b334f453e440d7d9cdfe18917b764cb05dff1d57ca99962816a3edec1c4"
  license "BSD-3-Clause"
  head "https://github.com/jacobwilliams/json-fortran.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b821255d59eebecf840d21eb2611db6c581a8e87e46f41e5caab870fe7cfda24"
    sha256 cellar: :any,                 arm64_sequoia: "1a426ceab43129311217d4bac2ca7c82c916839190e06c27f94f856a4c154e6e"
    sha256 cellar: :any,                 arm64_sonoma:  "e129cd071c41cd14c02dc0fdd5728a2faf60ebf8c4748cf79da50b76670ccd57"
    sha256 cellar: :any,                 sonoma:        "bedf218894bbba4af1c730534c2014ff9ac97cd7ddb4ffb859a2445b3af1cd97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4434c002ab2b8672dbd5f63b0cd43c51ce1bca5443b2a1b92576acd96e418eed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a81456d3ee0746cf86c4d2752774a35b91ba85fc7e9ba3c20ff56722f2d7c3a"
  end

  depends_on "cmake" => :build
  depends_on "ford" => :build
  depends_on "gcc" # for gfortran

  def install
    args = %w[
      -DUSE_GNU_INSTALL_CONVENTION:BOOL=TRUE
      -DENABLE_UNICODE:BOOL=TRUE
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"json_test.f90").write <<~FORTRAN
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
    FORTRAN
    ENV.prepend_path "PATH", Formula["binutils"].opt_bin if OS.linux?
    system "gfortran", "-o", "test", "json_test.f90", "-I#{include}",
                       "-L#{lib}", "-ljsonfortran"
    system "./test"
  end
end
