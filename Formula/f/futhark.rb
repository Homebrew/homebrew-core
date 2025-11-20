class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/refs/tags/v0.25.34.tar.gz"
  sha256 "69a8aa7d196f4ea995e7f986ada178db2aaebceda3344c600e7b3cfbecba96be"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "130084440e6543ab7a53108e2c99a35dfd3e32e3127feaa72302be8159341744"
    sha256 cellar: :any,                 arm64_sequoia: "3cd78e5471788499c116851a043458e539c83decf262512d63713f2665a0fbaf"
    sha256 cellar: :any,                 arm64_sonoma:  "914947277c70342f0a560cb45af27755d400322d29cbc4df4e5154860ff280e0"
    sha256 cellar: :any,                 sonoma:        "5cccec0cd5e51288c7ad29822a083868af3ddd3770061716a5f6850ff31993c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7feb520e7e96799258a737209f246bb6ad08e24d81f44e2092303486cd22aec3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1458802e265ff7a00dfd5ceca3a44df27812c1cf0768ec8946ed6368fd506366"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "sphinx-doc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args

    system "make", "-C", "docs", "man"
    man1.install Dir["docs/_build/man/*.1"]
  end

  test do
    (testpath/"test.fut").write <<~EOS
      def main (n: i32) = reduce (*) 1 (1...n)
    EOS
    system bin/"futhark", "c", "test.fut"
    assert_equal "3628800i32", pipe_output("./test", "10", 0).chomp
  end
end
