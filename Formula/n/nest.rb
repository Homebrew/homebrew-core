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
    rebuild 1
    sha256 arm64_golden_gate: "4526de21f025292a04991033ae3db0e4cd01d4514ab0870807b4b9f805076e75"
    sha256 arm64_tahoe:       "d92504fd5c36cad9f8074cd9e6e0a75c0fca51b4edcc70d9d08df489e48128b2"
    sha256 arm64_sequoia:     "a5488e8621d032e13576d5d597efdba3dbc99a8c356a53c8ae6d94db9dbfe821"
    sha256 arm64_linux:       "5e5315405e5cc62aba772793ca34e61643e1e4d7fea2ebc96587ae90b552f83a"
    sha256 x86_64_linux:      "cb32c5520f06bef7340c01be12e1dd12754f5c5eeeaa46444b9e78fdda46ad87"
  end

  depends_on "cmake" => :build
  depends_on "cython" => :build
  depends_on "gsl"
  depends_on "libtool"
  depends_on "numpy"
  depends_on "python@3.15"
  depends_on "readline"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "libomp"
  end

  deny_network_access!

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
      The PyNEST bindings and its dependencies are installed with the python@#{Language::Python.major_minor_version python3} formula.
      If you want to use PyNEST, use the Python interpreter from this path:

          #{python3.dirname}

      You may want to add this to your PATH.
    EOS
  end

  test do
    system bin/"nest-config", "--version"

    # check whether NEST is importable form python
    system python3, "-c", "'import nest'"
  end
end
