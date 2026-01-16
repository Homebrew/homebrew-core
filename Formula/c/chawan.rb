class Chawan < Formula
  desc "TUI web browser with CSS, inline image and JavaScript support"
  homepage "https://sr.ht/~bptato/chawan/"
  url "https://git.sr.ht/~bptato/chawan/archive/v0.3.2.tar.gz"
  sha256 "08f98ddf0040d0bf25dce62eac86d3ec5d2f11b2bc471213eb9c4c861a8d321a"
  license "Unlicense"
  head "https://git.sr.ht/~bptato/chawan", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "db9f8bd2ce7b8b69d8e88bdf33fa3192b756d64e96dc9e8c9dcafaaab31d6c0e"
    sha256 cellar: :any,                 arm64_sequoia: "3b94dd2fe4c7f4728c1aca6840ade71392fc2e111a65557efaea7183fc209e5c"
    sha256 cellar: :any,                 arm64_sonoma:  "84454a6d35fab701b0164106ac3f986154247dec3847da4ec2f943a5ba970127"
    sha256 cellar: :any,                 sonoma:        "640c06003a621dbd1eb0392484cb84b863a40376f31c37899f56fd287061df48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ca1c358adbd75dffaa42e264b765682da060209ca77731fb9085697f3d03ec2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "218b8a05150c5aae3239d57dfb610bf1543be63ca3ee9c32da93e7da23a15c7b"
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
