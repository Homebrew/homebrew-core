class Nest < Formula
  desc "Neural Simulation Tool (NEST) with Python3 bindings (PyNEST)"
  homepage "https://www.nest-simulator.org/"
  url "https://github.com/nest/nest-simulator/archive/refs/tags/v3.9.tar.gz"
  sha256 "8e67b9dcb72b029f24f3d70ff6d3dd64776dc21bf3e458c822c862677d67d076"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_tahoe:   "e7fcbd42855eb593039616db156047167d3fccc6f61b24f4d32cd622cf8c5547"
    sha256                               arm64_sequoia: "cb223513c56485f000e017ee6c8bb6bf08acd9d11355d50ce8ccbceb91a628cf"
    sha256                               arm64_sonoma:  "c8179fed8ebced6ec9352eeca00d832b1e6aa9f3545eb41cec5199c53e1fb392"
    sha256                               sonoma:        "2edddd7433fab4f1088d86fef0fc91eec7b2e4b301af08c9f4b345eeb81ad6cb"
    sha256                               arm64_linux:   "17fcfc3ec66d959a29c1ab12cd8f18021b06e1dd9afb2363183a101cb105d9b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87ae024785fb40c22e03f3bfea67fc1eb3ed3c924b582cc8b782c0f76f9fc680"
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
      The PyNEST bindings and its dependencies are installed with the python@3.14 formula.
      If you want to use PyNEST, use the Python interpreter from this path:

          #{Formula["python@3.14"].bin}

      You may want to add this to your PATH.
    EOS
  end

  test do
    # check whether NEST was compiled & linked
    system bin/"nest", "--version"

    # check whether NEST is importable form python
    system Formula["python@3.14"].bin/"python3.14", "-c", "'import nest'"
  end
end
