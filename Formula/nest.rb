class Nest < Formula
  desc "Neural Simulation Tool (NEST) with Python3 bindings (PyNEST)"
  homepage "https://www.nest-simulator.org/"
  url "https://github.com/nest/nest-simulator/archive/v3.3.tar.gz"
  sha256 "179462b966cc61f5785d2fee770bc36f86745598ace9cd97dd620622b62043ed"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "bd86e86c4725591e48faa03a59f2bc31d3bc91eca1dff6445a586cbf0592c62d"
    sha256 arm64_big_sur:  "03bc734c832fd24a0f2a46554c6c1b04f21c832861a2a478a946e6323a0847e5"
    sha256 monterey:       "2e726432e90deff4137df825c2996840f83557a679c979e7bb93763bc85bb5f9"
    sha256 big_sur:        "c2e1d71a36d08f0a89536f62743850c35118df7c6529cf8b285b9526eda90be8"
    sha256 catalina:       "f77781c41103a4cabdf5b7323761b70451ba0ced67d4266babf7b371b92aa0cf"
    sha256 x86_64_linux:   "250502b46ccc825980322c4b7511c520fe636d2ed46a3561e929529dbc35888f"
  end

  depends_on "cmake" => :build
  depends_on "cython" => :build
  depends_on "gsl"
  depends_on "libtool"
  depends_on "numpy"
  depends_on "python@3.9"
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
    python = Formula["python@3.9"]
    <<~EOS
      The PyNEST bindings and its dependencies are installed with the python@3.9 formula.
      If you want to use PyNEST, use the Python interpreter from this path:

          #{python.bin}

      You may want to add this to your PATH.
    EOS
  end

  test do
    python = Formula["python@3.9"]
    # check whether NEST was compiled & linked
    system bin/"nest", "--version"

    # check whether NEST is importable form python
    system python.bin/"python3.9", "-c", "'import nest'"
  end
end
