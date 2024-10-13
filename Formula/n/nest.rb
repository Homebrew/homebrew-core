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
    sha256                               arm64_sequoia:  "f752b4a7174c66b710b60ebb340d32d411332e06ea18d7da09660618754788c6"
    sha256                               arm64_sonoma:   "6653314027909fa7b2d3016afb0983cdd38ceb79d8103605287251419902e69a"
    sha256                               arm64_ventura:  "f8c15f21fd28ec67bd1adc7f5265123096a4b3837a54c12b39db7f02c54945a3"
    sha256                               arm64_monterey: "e29a15567400ebde27990ee78119903bca4fca61e69dbc2b63ff9791a0b6f03c"
    sha256                               sonoma:         "0a606967e870f9d74f29a0646c7852bd521ba1c2f1e3beff080d81de12036589"
    sha256                               ventura:        "1a324c3ad9977ca71a8fd89470414276394e7f2f56329516cc7bb372f4a5c343"
    sha256                               monterey:       "538f6bd318806ce37bb426d0b5c5d5fcba4770da28b5bfdb94049135e2526e47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a66f6b2a3b6b67b20f3506bef7be6a0aaec05366eddde02f2137ccc96ff2cf29"
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
