class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.23.1.tar.gz"
  sha256 "e6be2bb84ac655fd060f9c7a8625880ce8d72087ada6dfe349584a320974d6d1"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a421f4824b1d822246a177b3f9cd84972a8f380d29200896e9645b3d7189a76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5932ebd1683886f97183fe1e0ad5f4ef35720d329128b11a3900b9dab89381c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7232cb0562a71edafe19b03803297dfd4d5d1334b665356fa96eed59c0b210c"
    sha256 cellar: :any_skip_relocation, ventura:        "5c63e8474f01786cdf82345260f9f007848a54d01cc6b239643259fe354d1180"
    sha256 cellar: :any_skip_relocation, monterey:       "a960edf2c714294bfc1820a25f8c05aa74b14f60707bd48bc9c1489842adc79f"
    sha256 cellar: :any_skip_relocation, big_sur:        "e824a74062851a4e40d625f2f46592d9a2124f4aa9769a04b3e2d286ae84e028"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e6a342a7d36eaf0dd96ffb06ea5ab2a5f3e55bb20def2600586903b010b3c5a"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "sphinx-doc" => :build

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
    system "#{bin}/futhark", "c", "test.fut"
    assert_equal "3628800i32", pipe_output("./test", "10", 0).chomp
  end
end
