class Foma < Formula
  desc "Finite-state compiler and C library"
  homepage "https://github.com/mhulden/foma"
  url "https://github.com/mhulden/foma/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "32fff2bd0a8338716adfee71505277d8562dabd48be9bf15620c38b15c8c404e"
  license "Apache-2.0"
  revision 1

  livecheck do
    url "https://raw.githubusercontent.com/mhulden/foma/refs/heads/master/foma/CHANGELOG"
    regex(/v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "585a4ed242e82fa06b31fffea4747c3dcfb370d15b774ee2c099e89352494185"
    sha256 cellar: :any,                 arm64_sequoia: "54a82aed63a09cf0195f9473699e03bb64873b524684a4bab75eba204f80a97a"
    sha256 cellar: :any,                 arm64_sonoma:  "bc850a65c0df114711be58efc04e36402297f4f2df1a1c6ae2c303ab35bd80e4"
    sha256 cellar: :any,                 sonoma:        "20e9102b4df0a214b23c3eb5cd1d8b5e8d485b46c77e6e6913086889ac98f0c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fda34fa0f539af95305f663109e71bc25f679d9fa0712298c6b2785bdf94293"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d226105516d5b70e4981e53bb1fac0d8d7d61ba4fbae352c76c2f2223263f1f"
  end

  depends_on "bison" => :build # requires Bison 3.0+
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  uses_from_macos "flex" => :build

  on_linux do
    depends_on "readline"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "freeling", because: "freeling ships its own copy of foma"

  def install
    system "cmake", "-S", "foma", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Source: https://code.google.com/archive/p/foma/wikis/ExampleScripts.wiki
    (testpath/"toysyllabify.script").write <<~EOS
      define V [a|e|i|o|u];
      define Gli [w|y];
      define Liq [r|l];
      define Nas [m|n];
      define Obs [p|t|k|b|d|g|f|v|s|z];

      define Onset (Obs) (Nas) (Liq) (Gli); # Each element is optional.
      define Coda  Onset.r;                 # Is mirror image of onset.

      define Syllable Onset V Coda;
      regex Syllable @> ... "." || _ Syllable;

      apply down> abrakadabra
    EOS

    system bin/"foma", "-f", "toysyllabify.script"
  end
end
