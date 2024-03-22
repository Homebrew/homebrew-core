class Arrayfire < Formula
  desc "General purpose GPU library"
  homepage "https://arrayfire.com"
  url "https://github.com/arrayfire/arrayfire/releases/download/v3.9.0/arrayfire-full-3.9.0.tar.bz2"
  sha256 "8356c52bf3b5243e28297f4b56822191355216f002f3e301d83c9310a4b22348"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "865c6f979a09926528424dd8000734307b6312e684b8a7d71f0de9ee1f2fc1ce"
    sha256 cellar: :any,                 arm64_ventura:  "49e2ddc39ff3e3823e62c535a601bc0e137a9ec637050d981315b653166680d1"
    sha256 cellar: :any,                 arm64_monterey: "2459d0bf29599dd214224e2e7163d443057473c14b2d69fd1a2f11d3c5d8a040"
    sha256 cellar: :any,                 sonoma:         "499980917ef26007d417c08b3791030705291cc8e7cc99c060ef09c4747ed03a"
    sha256 cellar: :any,                 ventura:        "96f19e2b71e4c4c62763c8c5d3ae7295495368378b67b01eba06f70cb1e4d7be"
    sha256 cellar: :any,                 monterey:       "2fd4620360c08ada0b4df6c3ee90242a698672a391dbd1fbf67b69826e59381e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "823212b946aabd15bc03686fa64bb6be37b733322613c479bab570177eab882a"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "fftw"
  depends_on "fmt"
  depends_on "freeimage"
  depends_on "openblas"
  depends_on "spdlog"

  on_linux do
    depends_on "opencl-headers" => :build
    depends_on "opencl-icd-loader"
    depends_on "pocl"
  end

  fails_with gcc: "5"

  def install
    # Fix for: `ArrayFire couldn't locate any backends.`
    rpaths = [
      rpath(source: lib, target: Formula["fftw"].opt_lib),
      rpath(source: lib, target: Formula["openblas"].opt_lib),
      rpath(source: lib, target: HOMEBREW_PREFIX/"lib"),
    ]

    if OS.mac?
      # Our compiler shims strip `-Werror`, which breaks upstream detection of linker features.
      # https://github.com/arrayfire/arrayfire/blob/715e21fcd6e989793d01c5781908f221720e7d48/src/backend/opencl/CMakeLists.txt#L598
      inreplace "src/backend/opencl/CMakeLists.txt", "if(group_flags)", "if(FALSE)"
    else
      # Work around missing include for climits header
      # Issue ref: https://github.com/arrayfire/arrayfire/issues/3543
      ENV.append "CXXFLAGS", "-include climits"
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DAF_BUILD_CUDA=OFF",
                    "-DAF_COMPUTE_LIBRARY=FFTW/LAPACK/BLAS",
                    "-DCMAKE_CXX_STANDARD=14",
                    "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Remove debug info. These files make patchelf fail.
    rm_f [
      lib/"libaf.debug",
      lib/"libafcpu.debug",
      lib/"libafopencl.debug",
    ]
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/helloworld/helloworld.cpp", testpath/"test.cpp"
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laf", "-lafcpu", "-o", "test"
    # OpenCL does not work in CI.
    return if Hardware::CPU.arm? && OS.mac? && MacOS.version >= :monterey && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    assert_match "ArrayFire v#{version}", shell_output("./test")
  end
end
