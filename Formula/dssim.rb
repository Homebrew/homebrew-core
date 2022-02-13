class Dssim < Formula
  desc "RGBA Structural Similarity Rust implementation"
  homepage "https://github.com/kornelski/dssim"
  url "https://github.com/kornelski/dssim/archive/3.2.0.tar.gz"
  sha256 "b671aec5b117adb6f9c636ef70ecafbd671caacf8b110098565c01bf5171118f"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37a14733869d2c60062de1c8e655df3d1a137762623d0ac525541a654dbd3280"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36874bdc5fd412cb929c2c0479b098294b04337072cb3ebac9e11418e60b993b"
    sha256 cellar: :any_skip_relocation, monterey:       "6c799fd838f155f7f2a1924111a8daa9a009e0cbe052ff98ae497825d37f63ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "3933e21c8e0d2bad263d2dfb2d64c8d4129251daad7f7db918a114863c975d44"
    sha256 cellar: :any_skip_relocation, catalina:       "d2096852e5023b6a18c6c2d1abf042a77412734a0224241d88b5882c526aba6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77bb938ee05282258d50f9c709e0f71cfc85080146cae7a5b0386c62bc1798f2"
  end

  depends_on "nasm" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/dssim", test_fixtures("test.png"), test_fixtures("test.png")
  end
end
