class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2023.3.20.tar.gz"
  sha256 "b3ba6cca3b314a823232d64ad7d93b451e657314ab03aea9b0dfbf599a94d21f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24ac0a61ffeaa43f1c752f5415fb06cfa25cb79a7cb41d0da164729596473bf5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3c20f70b26d9d3cd1038fb9249011bf9813b771c83bd48c8934434cbdd34956"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ceb6bed09bc07699cd88566ffef9cd1e4eb380b5c3759b9cffaa058909d0847f"
    sha256 cellar: :any_skip_relocation, ventura:        "a3ec5801cd16ebebda9ca8ccd8edcf09943cae1ba3a4d10ad816202a03e75d02"
    sha256 cellar: :any_skip_relocation, monterey:       "ce64ef1c2b3d8c5a23cbf8809efcda3fa2b38922dded3f851ee056461d67882d"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff57ebc6f2753300c5d23e25e86b16598d2194d408e48a2e9b6f3a65c6a297a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49f71dae38d95f872fe9f3fb285abb6c5a535a14b701d42b0762cef3350f3683"
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
