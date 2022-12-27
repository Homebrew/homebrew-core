class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.22.7.tar.gz"
  sha256 "36e0347662b2ba143c25d6146731f808f9b6d192095aa5329e5fb891e49ce19a"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1462332f07913e26c839b96de709834789e160350f533db5cec7a5caeae1c36e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2340f46c674a97bd66bd2a5980b2db35a9ecfa1cb1d846ae4b082befcbb1835"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac67e8c0e8ccd2e0e28fc9e840cde5beb6ee8c13c6091ac8cd99871077c861ca"
    sha256 cellar: :any_skip_relocation, ventura:        "73edcba1c21ce0981020950d6616734fdadd2dee2f423bec23489d6636aff21d"
    sha256 cellar: :any_skip_relocation, monterey:       "dc568ce938d5bd8a6d04ac2b9fb9fa6487b3b4c0c28d9960f00aa61554d322e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "1db34e6b2903373e50c82b50c327852d079d724fb1e590c31ccb0226bc569d5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38e6a44ed52a85664df929978cb90b4ce868dcb1dc2939cbdad3e425f962bb52"
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
