class JsonFortran < Formula
  desc "Fortran 2008 JSON API"
  homepage "https://github.com/jacobwilliams/json-fortran"
  url "https://github.com/jacobwilliams/json-fortran/archive/refs/tags/9.2.1.tar.gz"
  sha256 "f1158a684a5328f6e5e970009ddb75284ef1fc4b85d6726e8cbfc6291a4e47a3"
  license "BSD-3-Clause"
  head "https://github.com/jacobwilliams/json-fortran.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "929c1b206838de37e6c22f75c00d7919e4c22d0e20ba5189cedee3dd822a43c8"
    sha256 cellar: :any,                 arm64_sequoia: "9f1eaeec1c66713cfd135385cf75e69ab7462d43ee95a4c90a4c722a12e3d8a0"
    sha256 cellar: :any,                 arm64_sonoma:  "f85987d41d3505338d41d570817f0ae000166b4f8bf7dfa4a2403390283b954e"
    sha256 cellar: :any,                 sonoma:        "13964a7249baa6b829a56f49d1762d2a3dec098523a148d7d37492675ee43ca7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31c6327981a6384db8fa92429cf52f5b0975bf1bed2957d12af9f4a3205fbc6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5edc1d769751635aafdb8ddb00be926afc981c53c7e180edced749091cc4ecca"
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
