class Nest < Formula
  desc "Neural Simulation Tool (NEST) with Python3 bindings (PyNEST)"
  homepage "https://www.nest-simulator.org/"
  url "https://github.com/nest/nest-simulator/archive/refs/tags/v3.10.tar.gz"
  sha256 "fd4def89c109e19d50e4630ab56bb9ddd4f15bf0ef735070189f0a83e2416a55"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "22e28550d2ade9e945536a8730ad9150fd46c9f69e4ae6c6d897757e5efcbd24"
    sha256 arm64_sequoia: "8d5ed9d180ca7126016616c3cf0ff31009b2692b6c524b4dd900ef6e9fd70b26"
    sha256 arm64_sonoma:  "0f36e77a6153f7dcb1cb5c51c939e1bafa148ccd1a096a305283bc3dc86ffde1"
    sha256 sonoma:        "a51dc3b73e9f094a305a2e6e75c3503e13dcb94cd134ab996a21f5c0d5b3a9ad"
    sha256 arm64_linux:   "486e4437cb5e5e910aa80c5ab5e768e9ef123a36f61d5161c824f4451a5f6822"
    sha256 x86_64_linux:  "e68d65b7a442a6dbb459359ddd6e49877d3306d90a78910b1931c1cf93e4e275"
  end

  depends_on "cmake" => :build
  depends_on "cython" => :build
  depends_on "gsl"
  depends_on "libtool"
  depends_on "numpy"
  depends_on "python@3.14"
  depends_on "readline"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "libomp"
  end

  def install
    # Help FindReadline find macOS system ncurses library
    args = if OS.mac? && (sdk_path = MacOS.sdk_path)
      ["-DNCURSES_LIBRARY=#{sdk_path}/usr/lib/libncurses.tbd"]
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
      The PyNEST bindings and its dependencies are installed with the python@3.14 formula.
      If you want to use PyNEST, use the Python interpreter from this path:

          #{Formula["python@3.14"].bin}

      You may want to add this to your PATH.
    EOS
  end

  test do
    system bin/"nest-config", "--version"

    # check whether NEST is importable form python
    system Formula["python@3.14"].bin/"python3.14", "-c", "'import nest'"
  end
end
