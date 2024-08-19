class JsonFortran < Formula
  desc "Fortran 2008 JSON API"
  homepage "https://github.com/jacobwilliams/json-fortran"
  url "https://github.com/jacobwilliams/json-fortran/archive/refs/tags/9.0.1.tar.gz"
  sha256 "1a6fd50220527d27ba0a46113b09b4f5cb5a48a0d090ddc36d3fddf6cf412e56"
  license "BSD-3-Clause"
  head "https://github.com/jacobwilliams/json-fortran.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "18a825c6290c6e125fc8132817bf0ef18fd347e009fa6fdebd18cf748450488d"
    sha256 cellar: :any,                 arm64_ventura:  "5679db7855d5649e88ba81eb75b154ef3fbadadde933ca696c7a5ead23b10378"
    sha256 cellar: :any,                 arm64_monterey: "73e456818c12d2b5c3aab5ec6266bef8ce0c2c5213a3da3f14292bfe4a2ed94c"
    sha256 cellar: :any,                 sonoma:         "24de693925d52392fbf9ddf04b016f4fe27cddce7354a259aa59271ed6fe6179"
    sha256 cellar: :any,                 ventura:        "342a619d26bd30cd693d78c1e6251dad291a1575857e6d44b2a8a79c28e5c55b"
    sha256 cellar: :any,                 monterey:       "6d6fb70e2f8978026661991296b9cce9c15aba7a6ee17a903e2718130e4d328f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81649d3140d1f3ac4aa924c865e0758999702f8a45e4e0268b4456975b2fd57b"
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
