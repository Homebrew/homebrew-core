class Nest < Formula
  desc "Neural Simulation Tool (NEST) with Python3 bindings (PyNEST)"
  homepage "https://www.nest-simulator.org/"
  url "https://github.com/nest/nest-simulator/archive/refs/tags/v3.8.tar.gz"
  sha256 "eb255f8828be001abea0cddad2f14d78b70857fc82bece724551f27c698318c8"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256                               arm64_tahoe:   "ecdcb809374fd3ac133209090f0c4736018c36cfb315d5f2d93a25b69adbb908"
    sha256                               arm64_sequoia: "77726b6e71f853c6df098f2d831f9a0af988f6bf7d31603da31d5b724af38e40"
    sha256                               arm64_sonoma:  "8b96f0a8dc01bfd65c16a3a0c837e50b020b4a609fc4fed7e20af4fad94c479c"
    sha256                               sonoma:        "459ff70045a53b33d2a08c6a543f1c02170a82b72d12b32e70e64401eb5a9aec"
    sha256                               arm64_linux:   "ec8f35f23f1bd5693753ff042718a8f21743d5396df3496f8c1a426a87394664"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "091d19e726b0c3a4d99748a2b8ad2d9308ad89aa12fd856c019e475ecfc9651d"
  end

  depends_on "cmake" => :build
  depends_on "cython" => :build
  depends_on "gsl"
  depends_on "libtool"
  depends_on "numpy"
  depends_on "python@3.13"
  depends_on "readline"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "libomp"
  end

  # Fix to error undeclared name not builtin: long
  patch do
    url "https://github.com/nest/nest-simulator/commit/cb7e1dadf8a8566b7340ad3a7ed13c173d35e6d0.patch?full_index=1"
    sha256 "056fa912d7570bd98e2114355a5d0a6ca2bc0bc8cfd362bf39625dfc9df93c47"
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
      The PyNEST bindings and its dependencies are installed with the python@3.13 formula.
      If you want to use PyNEST, use the Python interpreter from this path:

          #{Formula["python@3.13"].bin}

      You may want to add this to your PATH.
    EOS
  end

  test do
    # check whether NEST was compiled & linked
    system bin/"nest", "--version"

    # check whether NEST is importable form python
    system Formula["python@3.13"].bin/"python3.13", "-c", "'import nest'"
  end
end
