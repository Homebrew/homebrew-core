class JsonFortran < Formula
  desc "Fortran 2008 JSON API"
  homepage "https://github.com/jacobwilliams/json-fortran"
  url "https://github.com/jacobwilliams/json-fortran/archive/refs/tags/9.3.0.tar.gz"
  sha256 "7f29ded5283ba62b0ee9829ffe860326a17bef207ee9d6cbe68bb7cc3ecf1cfc"
  license "BSD-3-Clause"
  head "https://github.com/jacobwilliams/json-fortran.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "26e45bc068ea5ec11f2c963326ff627aae34e6c1abdfba61797febcfae7261d7"
    sha256 cellar: :any,                 arm64_sequoia: "59bf7aa895b1325a553193ee0b9bce9e4bfdd0096fd2d981ea24febcc5513982"
    sha256 cellar: :any,                 arm64_sonoma:  "00155050c910fbb755c5deb12011afb87c6449164ca937a80ccdd9c1e681e59b"
    sha256 cellar: :any,                 sonoma:        "4afb4b9e2a4b19872cbd184becce1245c36824cf7e1226db61a816a6b3cca4f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffea2a7d7fd6a06ccd740c08b01e0b1e83c0dffa5731c730ee6a3e024d98277a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de087dcfe595a1f471e5696e1addbc75f5e0a40c81affd45aa5fde60f61e6d95"
  end

  depends_on "cmake" => :build
  depends_on "ford" => :build
  depends_on "gcc" # for gfortran

  # Fix bad Unicode introspection source path, upstream PR ref, https://github.com/jacobwilliams/json-fortran/pull/630
  patch do
    url "https://github.com/jacobwilliams/json-fortran/commit/5182811edf258c85a405dfad76985885bd0159ab.patch?full_index=1"
    sha256 "94688e5718dc2bad696521a3a1ad38503af4c37edab38ebb7c5a6f07ff7f648d"
  end

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
