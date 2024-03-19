class Nest < Formula
  desc "Neural Simulation Tool (NEST) with Python3 bindings (PyNEST)"
  homepage "https://www.nest-simulator.org/"
  url "https://github.com/nest/nest-simulator/archive/refs/tags/v3.6.tar.gz"
  sha256 "68d6b11791e1284dc94fef35d84c08dd7a11322c0f1e1fc9b39c5e6882284922"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256                               arm64_sonoma:   "375af4a21572a8c8a8992591c15f4533ec9bc3031e95b633969d842dd99d8c84"
    sha256                               arm64_ventura:  "ba3c8aa598f7702e6134221924ac3689754c3e3c97de404a846d4a2eeb4c7d27"
    sha256                               arm64_monterey: "becb04c85ad79df087239f165c5ee9fa9fc52daacbcff97c5e44d0f3f4be7c80"
    sha256                               sonoma:         "ab566c2c64c5e805ec1632354388f65293eb9fe3cb54b1ddfbd50371171c7d63"
    sha256                               ventura:        "be1d2a8920d7ee3cc5fc9f3f4f0cfcdf810653f06d5f49cd56106d71df29aabd"
    sha256                               monterey:       "1487adf49b7e0a7e3fe8a1cbed04b8238530a6f32b2951f4a3ac540bee4ae9b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e1f100fd4c7512f3a543b46c1b85263d6eca26fb47fb008e60e9d0ba4ae824b"
  end

  depends_on "cmake" => :build
  depends_on "cython" => :build
  depends_on "gsl"
  depends_on "libtool"
  depends_on "numpy"
  depends_on "python@3.12"
  depends_on "readline"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "libomp"
  end

  def install
    # Help FindReadline find macOS system ncurses library

    args = if OS.mac? && (sdk = MacOS.sdk_path_if_needed)
      ["-DNCURSES_LIBRARY=#{sdk}/usr/lib/libncurses.tbd"]
    else
      []
    end

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Replace internally accessible gcc with externally accessible version
    # in nest-config if required
    inreplace bin/"nest-config", Superenv.shims_path/ENV.cxx, ENV.cxx
  end

  def caveats
    <<~EOS
      The PyNEST bindings and its dependencies are installed with the python@3.12 formula.
      If you want to use PyNEST, use the Python interpreter from this path:

          #{Formula["python@3.12"].bin}

      You may want to add this to your PATH.
    EOS
  end

  test do
    # check whether NEST was compiled & linked
    system bin/"nest", "--version"

    # check whether NEST is importable form python
    system Formula["python@3.12"].bin/"python3.12", "-c", "'import nest'"
  end
end
