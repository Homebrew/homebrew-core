class Nest < Formula
  desc "Neural Simulation Tool (NEST) with Python3 bindings (PyNEST)"
  homepage "https://www.nest-simulator.org/"
  url "https://github.com/nest/nest-simulator/archive/refs/tags/v3.9.tar.gz"
  sha256 "8e67b9dcb72b029f24f3d70ff6d3dd64776dc21bf3e458c822c862677d67d076"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_tahoe:   "065df993ca2c0bde55060073cfe54e12844b3e8b5f94e13b5d5a77919ea92b1a"
    sha256                               arm64_sequoia: "70045b182e97cdcb9b51d99ba0f3c53f84566dddec80c1e1e98f69701c789c5c"
    sha256                               arm64_sonoma:  "c848332448d8914ae7ab34424650c41714a6c44fcac3e2f7f51594da42badf8e"
    sha256                               sonoma:        "15b4296b41bebab8cea62840c22806d55989029e3fba0ad10c05e961da3ad2eb"
    sha256                               arm64_linux:   "7d7be1baad034757222d9633f129fa3d17b2ba18313d7a44d2bf762c6404dec3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38afd26389b92c2425a3b7ef6ffecf12dc9e597dba4fada55ea101ac51ef5ea3"
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
