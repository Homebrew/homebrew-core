class Chawan < Formula
  desc "TUI web browser with CSS, inline image and JavaScript support"
  homepage "https://sr.ht/~bptato/chawan/"
  url "https://git.sr.ht/~bptato/chawan/archive/v0.4.3.tar.gz"
  sha256 "46529fb27c4b88966444f76c5b5dabd61588b5b186b2949addb611db45af6d1a"
  license "Unlicense"
  head "https://git.sr.ht/~bptato/chawan", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bf9417370d67d2be7f92fd31a8d1b112486099144133cefe60a3db9b7a76ce2a"
    sha256 cellar: :any, arm64_sequoia: "742e196f59b8ec83acd172c57d932b096dc5a1877eb95810b990cbd3103e460e"
    sha256 cellar: :any, arm64_sonoma:  "3dd82f03461dbb7554b75b4b0888bc2e96edf38d8f198f9e730e9d872b8f8224"
    sha256 cellar: :any, sonoma:        "246f6d5e965482e2cd3e26c9fb929068cb43bccc9bfe39393dc25782f51e58db"
    sha256 cellar: :any, arm64_linux:   "ca8e035e0f57e849c9e3d281f3504962dadec1ca38e08a5f31efd98e6ac9c0b2"
    sha256 cellar: :any, x86_64_linux:  "6ef2d60dd74a5986d969fcca0017b66ff790b123e9a32fa3a8fa0fe3cc98b321"
  end

  depends_on "nim" => :build
  depends_on "pkgconf" => :build

  depends_on "brotli"
  depends_on "libssh2"
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cha --version")
    assert_match "Example Domain", shell_output("#{bin}/cha --dump https://example.com")
  end
end
