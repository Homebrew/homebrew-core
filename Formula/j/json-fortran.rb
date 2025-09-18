class JsonFortran < Formula
  desc "Fortran 2008 JSON API"
  homepage "https://github.com/jacobwilliams/json-fortran"
  url "https://github.com/jacobwilliams/json-fortran/archive/refs/tags/9.0.5.tar.gz"
  sha256 "8ec27366be7f861cd14b277fd997be1ebee2a7e776a0b904b6f2425f0a274984"
  license "BSD-3-Clause"
  head "https://github.com/jacobwilliams/json-fortran.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "db7983b84f338dc340b2a5d048a594a6485163111e06f142821c4f58ca935fb0"
    sha256 cellar: :any,                 arm64_sequoia: "95e2b55cd22d58db1a7d4e06031e8406b0996c2355eedf82252fef0da426288c"
    sha256 cellar: :any,                 arm64_sonoma:  "034c9f09b82cc5059bd8eda6e5cc8b2fd4b8f85d3ceed9dd395af278ffcfb911"
    sha256 cellar: :any,                 arm64_ventura: "263f2ab82b9e7cb1f096bc3b7070d2661b9f5f9e468e95ac2e2ee3d8f7996c80"
    sha256 cellar: :any,                 sonoma:        "d73925b181a63ef1a688338ca3bd21d186a5e95e63d03ccd680204dd392dde97"
    sha256 cellar: :any,                 ventura:       "493827bdff025af9d3498910670cab02973956c5aac4401cbc272dc645b69411"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab9ebab961b0d954edb45c536145f3377ef28dc9adddc85d9dcc7af3b4da7293"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0086a54d347650b20241c3fa86c46e6a66e594cce78ce1641fd086dd57323785"
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
