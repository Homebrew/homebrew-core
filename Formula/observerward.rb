class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2022.9.6.tar.gz"
  sha256 "230434f4a19a19d0d1428ecf0e8224d56a3ce2a15796d06de28611d7234db060"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4310a01bc54a2893ee99f85dcf27abfe5ad2eb3501295d62f80166f32dd0f0a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "574082e5bb6705ce929f2dea540104b89654f3c1ff9907b08baed87cb4463cc0"
    sha256 cellar: :any_skip_relocation, monterey:       "8eeddd95d28a3ed6c4d3bb378c02363fe4fa7894a7ea2dd2fb4cf7be065c7ec3"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c8aff746fc6438be586bcc8352856dfc6abb95b66a2d1869589e22ad1968a65"
    sha256 cellar: :any_skip_relocation, catalina:       "b97a4faef14b45f27218a1f4a371e7d0994f8e35e1043220abaa2487c00716a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a902074c66b9b1f6be9b2063bf51d3e5b434659a36e16331ccfef94acb24b3fe"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"observer_ward", "-u"
    assert_match "swagger", shell_output("#{bin}/observer_ward -t https://httpbin.org")
  end
end
