class Nest < Formula
  desc "Neural Simulation Tool (NEST) with Python3 bindings (PyNEST)"
  homepage "https://www.nest-simulator.org/"
  url "https://github.com/nest/nest-simulator/archive/v3.4.tar.gz"
  sha256 "c56699111f899045ba48e55e87d14eca8763b48ebbb3648beee701a36aa3af20"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256                               arm64_ventura:  "202bf506eee609266a785c44239245c7547507e7288da47ff3b8fb8fec2708ec"
    sha256                               arm64_monterey: "bef80232f6f104a6f8579d473666b3fdcca6770371bc759597f1b1d7bf611b5a"
    sha256                               arm64_big_sur:  "ea9c3be7589d90d05fd5248f5b78de8d596ee6b327ed2bea66f99a692b2275f1"
    sha256                               ventura:        "8e0e1e6a7a109935098625cc9369af9e9527f86ea28128ce3b3f2a42645b678e"
    sha256                               monterey:       "93bd3a502a1c92f7218d75ce879b2791a97cd47c71ea5ae13d3158a1b2f9c67f"
    sha256                               big_sur:        "ce0fe028545fbca388b836e58b4d8369e110311d266cdf7934211881fba9dbdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac6daaf0940720959bafc691d7a1b8da7a49f4d1a569640cc6164f5b1e1af121"
  end

  depends_on "cmake" => :build
  depends_on "cython" => :build
  depends_on "gsl"
  depends_on "libtool"
  depends_on "numpy"
  depends_on "python@3.11"
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
      The PyNEST bindings and its dependencies are installed with the python@3.11 formula.
      If you want to use PyNEST, use the Python interpreter from this path:

          #{Formula["python@3.11"].bin}

      You may want to add this to your PATH.
    EOS
  end

  test do
    # check whether NEST was compiled & linked
    system bin/"nest", "--version"

    # check whether NEST is importable form python
    system Formula["python@3.11"].bin/"python3.11", "-c", "'import nest'"
  end
end
