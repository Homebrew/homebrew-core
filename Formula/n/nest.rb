class Nest < Formula
  desc "Neural Simulation Tool (NEST) with Python3 bindings (PyNEST)"
  homepage "https://www.nest-simulator.org/"
  url "https://github.com/nest/nest-simulator/archive/refs/tags/v3.7.tar.gz"
  sha256 "b313e03aa05a0d8053b895a1d14ea42e75805393c6daa0cbc62f9398d0dacd8b"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sonoma:   "d8b6f375dd91854a2019107067d37cab2e8fddf212cb5f14ad22b78df3f62f95"
    sha256                               arm64_ventura:  "450cd92dbdd35eb7abc7bf3d153009467c003200027ded3421476a5db58588ad"
    sha256                               arm64_monterey: "403724ac34f70f8e7eb799c6c65c51e6deaae9dda6704c5f4b83295efd46dda8"
    sha256                               sonoma:         "c2f6f9f9e7da9cdacc2b0e02c94c951754fdd127f4231bee201d2f741ebf7d8c"
    sha256                               ventura:        "cb01045dcc973483758fcf25cf85b13bd66b04946e96ec765498b183e5b8b0a6"
    sha256                               monterey:       "9adb040c9a483a2c78e4577f2e70073cae0a3d62320cbf1e07860183d14fe2da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d72a4770d6ee708903519ffa6bdec6aca32f950cfb17f91d36140f04687e57b"
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
