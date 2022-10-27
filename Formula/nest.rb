class Nest < Formula
  desc "Neural Simulation Tool (NEST) with Python3 bindings (PyNEST)"
  homepage "https://www.nest-simulator.org/"
  url "https://github.com/nest/nest-simulator/archive/v3.3.tar.gz"
  sha256 "179462b966cc61f5785d2fee770bc36f86745598ace9cd97dd620622b62043ed"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 arm64_ventura:  "5f8750382c6a6fc932d279c8146ab28b919cd4a6d24dcb47f34942ccb52ac154"
    sha256 arm64_monterey: "4173ccaf82e72b43f9633c541579dd73965fee0de632881e3a27689277f4d7f5"
    sha256 arm64_big_sur:  "6f2a955de6185ab1da109a32ffac7fb6f99e8b41776e963b67bb8d67f5fe3974"
    sha256 monterey:       "c7ecebf829cc51d4028e539adc31bf5521094f06bf5c8dc63100c056bb002037"
    sha256 big_sur:        "dd7a521295ac1a4fd79b7eb1849eaa4362fd5cb543803793cf10397df0501b5f"
    sha256 catalina:       "648ea3fcf3cf6ac164b5fc880208b7ed671e07af1f81760256f5895357e79bea"
    sha256 x86_64_linux:   "fa76ea85f9a48e0faa0e7620a39e7621f795dc33f3623f8a0d6d5b7577567e6b"
  end

  depends_on "cmake" => :build
  depends_on "cython" => :build
  depends_on "gsl"
  depends_on "libtool"
  depends_on "numpy"
  depends_on "python@3.10"
  depends_on "readline"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "libomp"
  end

  def install
    # Help FindReadline find macOS system ncurses library
    sdk = MacOS.sdk_path_if_needed
    args = sdk ? ["-DNCURSES_LIBRARY=#{sdk}/usr/lib/libncurses.tbd"] : []

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Replace internally accessible gcc with externally accessible version
    # in nest-config if required
    inreplace bin/"nest-config", Superenv.shims_path/ENV.cxx, ENV.cxx
  end

  def caveats
    <<~EOS
      The PyNEST bindings and its dependencies are installed with the python@3.9 formula.
      If you want to use PyNEST, use the Python interpreter from this path:

          #{Formula["python@3.10"].bin}

      You may want to add this to your PATH.
    EOS
  end

  test do
    # check whether NEST was compiled & linked
    system bin/"nest", "--version"

    # check whether NEST is importable form python
    system Formula["python@3.10"].bin/"python3.10", "-c", "'import nest'"
  end
end
