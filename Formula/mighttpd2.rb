class Mighttpd2 < Formula
  desc "HTTP server"
  homepage "https://kazu-yamamoto.github.io/mighttpd2/"
  url "https://hackage.haskell.org/package/mighttpd2-4.0.0/mighttpd2-4.0.0.tar.gz"
  sha256 "5afc8acb4e268401dc19964b710230e5013399b8ad3baa7ae6d5e5802ad4ac42"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb4f3d679f45eb1cafeef1382405c56ff3a12163557921f522d04d8515072556"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a3795338aecf816f75d65a1b94306a7ad10ce00ce06f542ba4ba70c9d6633b3"
    sha256 cellar: :any_skip_relocation, monterey:       "9b40c73cbea84c5a873d4fb2a42434e21fc78ee605fb034e74be85c1a845cf55"
    sha256 cellar: :any_skip_relocation, big_sur:        "b47d66f64181fb396631c5d7811a45af16b15fb709b04f877beb1dd53defe2bf"
    sha256 cellar: :any_skip_relocation, catalina:       "ccf3d9edc4c2f4816fb03a3de973d28d8e19798c696d57eab63cbbebe9064af3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "233acd9876e3aff534a0aadd6f78d6f0f187af11d56a676cc3f15bf3d37c02ec"
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
