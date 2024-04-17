class Nest < Formula
  desc "Neural Simulation Tool (NEST) with Python3 bindings (PyNEST)"
  homepage "https://www.nest-simulator.org/"
  url "https://github.com/nest/nest-simulator/archive/refs/tags/v3.7.tar.gz"
  sha256 "e1fb8dc4724887a3a2bfbaa9e86f2ef1d458a4535f8c54e328c4dcb3bc426d40"
  license "GPL-2.0-or-later"

  bottle do
    sha256                               arm64_sonoma:   "10fc72494dc3b79d38161b9c93c78c65a50e0622ef488f5e39229c4a9155563d"
    sha256                               arm64_ventura:  "32d34c0e7070b2629753f94569b3b4a55c11c124933215b20a9f192d4e8d67d8"
    sha256                               arm64_monterey: "28cc1b60c343c517b2f6166fa8de49cde629653064e4461201d66a24d256e201"
    sha256                               sonoma:         "0a07c805f77528acfe86cd3a4748daf0a5f82f0b6a28f1466f7231b832cfd0be"
    sha256                               ventura:        "9c7f94429e38956b84c94fc7aa8629def9cc457ba175fdfd16d4e9de9308daf4"
    sha256                               monterey:       "171db9866dd53687b64b14c58172427d83881fc5db988c4711576304d5cf6218"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "806e44551a768ef0352e068c4b64b36d76b9792cec6236a5ac2f133d99512c68"
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
