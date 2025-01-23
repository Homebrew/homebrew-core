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
    rebuild 1
    sha256                               arm64_sequoia: "1a34d790312185592e775e4e8fe4aef7383006d5043b7c97847d3c0d7db56394"
    sha256                               arm64_sonoma:  "7d9f9e7ad474c91f30af1f8befd084621a645b6753780c98a03c3bda4c39f681"
    sha256                               arm64_ventura: "e4997e4c854f79114bf6126b93073cedd165b443f14d1086f7a246690b77b547"
    sha256                               sonoma:        "c6628a5bb1198d80c5c1e56a2bdea010d585c067bac0603a744bf1f009191b8a"
    sha256                               ventura:       "a77c3c6db49b56fe36710c8a05bfc36dc4604bc8bd5448ceb7744fdf216ce86c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e29d5b0a924beffaed5eef267c5c08b78529d3894a8099578d68e0853fb0d65"
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
