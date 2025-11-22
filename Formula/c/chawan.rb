class Chawan < Formula
  desc "TUI web browser with CSS, inline image and JavaScript support"
  homepage "https://sr.ht/~bptato/chawan/"
  url "https://git.sr.ht/~bptato/chawan/archive/v0.3.0.tar.gz"
  sha256 "d97319848ceb98407dc4ba2303bec48787ab1e444cd166eeb0b928360ebda08d"
  license "Unlicense"
  head "https://git.sr.ht/~bptato/chawan", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e0924459035d7c85df465d6092bdb8a7b9f4244d1568e9d38aef2fe5aac9cba0"
    sha256 cellar: :any,                 arm64_sequoia: "367ad8dab2a09ef3e0f7ac23062d5d7a4051fd5285a5f49c8f3a6133f7f2c7ce"
    sha256 cellar: :any,                 arm64_sonoma:  "049c11d7fb9528ae5f5dafea2f02b067514aa1ab4b4ea1f30eb626f61df6d798"
    sha256 cellar: :any,                 sonoma:        "7674a00fdf9253a5a91f61633a332834e07eca09c5a080a985f014035632d0ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b154e6e21100490b4d6d5ee908e4eb1dd170c2295399c70c5cf91c32f16afba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ca0c1a9f3278bc9428f40bb7cca7ee05367b3e2f3911c5eb34e3eaa8ca8f6d6"
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
