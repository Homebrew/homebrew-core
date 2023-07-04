class Nest < Formula
  desc "Neural Simulation Tool (NEST) with Python3 bindings (PyNEST)"
  homepage "https://www.nest-simulator.org/"
  url "https://github.com/nest/nest-simulator/archive/v3.5.tar.gz"
  sha256 "4504ff7f9cfa051c91a5e85a0761bdd09d23aeeadac22c45f6be18b7fbe2db43"
  license "GPL-2.0-or-later"

  bottle do
    sha256                               arm64_ventura:  "df23c97bb58253cf7ad02f5f282f3e80b44f9ac2cc8abbfbf1218e79ca03a5d7"
    sha256                               arm64_monterey: "377cd61eefe12f39600b094e04770fc3463d824fb7a78b935798ba61c8f7e555"
    sha256                               arm64_big_sur:  "90b4e88fcd273aadb85a2cc8a6bbd4eea290ed89dad72dd61cebb05d4b35cfe4"
    sha256                               ventura:        "9d0b26661d317418c7dd942fb22efacfd4ee538e35dea644b027bfc05f7ee1db"
    sha256                               monterey:       "30d4afb77804602c8ddc7500fcb72876b3846d4420b5cff10a68830a6eaaa4f8"
    sha256                               big_sur:        "402eb3684c5402856dece4dda8ff30d2c63dd864e4bad3bf5fb1e41174437fc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dea095e6f50281a9904e66b8b05b9007bebb69105620fb4c6b64633a23c2bfcb"
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
