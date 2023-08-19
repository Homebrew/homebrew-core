class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.25.2.tar.gz"
  sha256 "e76e6d821f641e0cc7c0c85532fd46702ddf3bf9326ecddec46010d36069512a"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac0eb68bda99c78f22a08b53b77b6e1905ce8242c78e0b07efe87a1b43e10042"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e60243de032b0ee05b4fb35e41a12344b06f7fdaa061fc8969e0739f7350f1d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef20ab9ddf1ae9111d6fdac4c6adfc3bbcc2b5ca3ea80a5a453111aa85bc8a3a"
    sha256 cellar: :any_skip_relocation, ventura:        "9992a887b6a598593b427ccd8946469ece2c26b674a8738f53f26b34996f650d"
    sha256 cellar: :any_skip_relocation, monterey:       "8f465ef4935b354e9b7b33dc4a325f1aba31d6e5c7863a2ab3f289e7bff9ba27"
    sha256 cellar: :any_skip_relocation, big_sur:        "e27458ceee2da93cf1f477ddf74412e463b6a4de336135923ac1baccae681f60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6083d5e4455dd67d4be9d2b96341e2e28e75d74f9f7f5826aea6cc7f437d1574"
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
