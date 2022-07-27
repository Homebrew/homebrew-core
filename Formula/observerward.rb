class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2022.7.27.tar.gz"
  sha256 "cf2d4cb334611520eccb24578eafa679fb5a9a11e53c04620c833c774110c769"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf510997c8b8f24c13fa7e5573559c9c5f451870519a3e4982afbe146fb04894"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30264030dc68a99a6a8bf6017a3993e6a67987550f9dc246a5ccc3c1aeb76d02"
    sha256 cellar: :any_skip_relocation, monterey:       "80b67c49412555cc6c47789d8070347d6d6ea62443f8b83f1fdb5bafbf72ea33"
    sha256 cellar: :any_skip_relocation, big_sur:        "418aad0f546e9651677d7050bef504f2d556a5eb2a7d0031be02f24bdf660c09"
    sha256 cellar: :any_skip_relocation, catalina:       "443e24786416a9d5e0658f4a5bd13911b1bd55bc48ea81a1497312ad3673ac61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0e32f5c65bc083c85a1ee3ea3393571a4d56f3eabed6300b4026ed02ad039b7"
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
