class Mighttpd2 < Formula
  desc "HTTP server"
  homepage "https://kazu-yamamoto.github.io/mighttpd2/"
  url "https://hackage.haskell.org/package/mighttpd2-4.0.2/mighttpd2-4.0.2.tar.gz"
  sha256 "1d4dc43b96a3064a8c0b752f71591cb04d769b76e3b922a5ea3529057d530960"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e432ae1973470224bb1aaf5ae3ef7b70d20be866560f2ec4c0375c1962e7af30"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3fea445ba4059d1f0babdbf7d2133ae1a6cda242a636285e2fe93a816a6c7e73"
    sha256 cellar: :any_skip_relocation, ventura:        "b18cfc5ecf3d042427cb214d92d8ba4bac0b99bb871f7fe91265dd00f67c021f"
    sha256 cellar: :any_skip_relocation, monterey:       "483bcb477d2ae4f5de053e35bdfa241797d5f71fa7a1a634ffa796ad293d6574"
    sha256 cellar: :any_skip_relocation, big_sur:        "483de36504302bc062927309c91e69596f74aad25252bb45cfc771736675f2f0"
    sha256 cellar: :any_skip_relocation, catalina:       "da5f1934cd56641f992af9e702d5269e70ee960c9ea93a039b974b2aaa0fad5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fe18c418eaf8ca67edc56fb5e3c68e0efc2afc4efa8f651d1554a5668aa72fc"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", "-ftls", *std_cabal_v2_args
  end

  test do
    system "#{bin}/mighty-mkindex"
    assert (testpath/"index.html").file?
  end
end
