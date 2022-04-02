class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2022.3.31.tar.gz"
  sha256 "6f5625084a0ceee1a3f32c867dd9a2f64e5991497a2f43129846f45ed56d5da1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75627cc79d90a4acab68363f35c6b08d4ed93d97a77d77ae25c61ea15394ada4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b8618a789ebd6fe167a929aee748d2a0f16baec85c98cd52311bc478099c256"
    sha256 cellar: :any_skip_relocation, monterey:       "63e0ce0a52384aadf98fe9c5c3aef759412e29a3802a0d6b6d2634dbd4935468"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c79d19ca239789e0b9964f6597614758f5ffec58f1bd975e7b99538c0a055c7"
    sha256 cellar: :any_skip_relocation, catalina:       "cf1f82bb4b8f63711b571c0180893a8495c73ae1be3b8c4db79bfb9476b9f325"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0de5c1e7aa8289a43408f8dfe0a916559056b37d4c7c0a2ed6c48219fb990b83"
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
