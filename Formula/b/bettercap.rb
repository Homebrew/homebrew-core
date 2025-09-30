class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/refs/tags/v2.41.4.tar.gz"
  sha256 "384848630f594fadd48e80406f4cf8ceccfe3f32dd9182f7e18c20240e74a5fd"
  license "GPL-3.0-only"
  head "https://github.com/bettercap/bettercap.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a5d2ccf8e44bcd750a3c1216174162ef4ceeed0dcf7573c58bc3b9a5b0d0c2ca"
    sha256 cellar: :any,                 arm64_sequoia: "4207804c76606309568c517aca44e7cfc16b17c4536890d529db11e613ff9c90"
    sha256 cellar: :any,                 arm64_sonoma:  "9f27f57bf5b09da4bfc0452598b25b6e63e25bbfa6f24c8319fb359c4c8a21c6"
    sha256 cellar: :any,                 arm64_ventura: "93b814c4cbfd843d1ae14c5bf401cad13f0cf06e3a91acb6b8d2b00967c321b5"
    sha256 cellar: :any,                 sonoma:        "6a7de7c04fc89cbb75a69ac6e8313fe59ab1cf5258042c8d9fb2f8b76655daf5"
    sha256 cellar: :any,                 ventura:       "99ab3ba1e0575352325dd1c179d55dc3235a082a415d22a3b45d1470df4daa76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5935ba6b62d8519bccd82dcfc24a746804261d384751f85e60508cf0c26eb2fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d89986f7aa57f5b2303029cfb5b929498fb6f47cb54290fdc97b530feca594d"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "libusb"

  uses_from_macos "libpcap"

  on_linux do
    depends_on "libnetfilter-queue"
  end

  resource "ui" do
    url "https://github.com/bettercap/ui.git",
        revision: "6e126c470e97542d724927ba975011244127dbb1"
  end

  def install
    (buildpath/"modules/ui/ui").install resource("ui")
    system "make", "build"
    bin.install "bettercap"
  end

  def caveats
    <<~EOS
      bettercap requires root privileges so you will need to run `sudo bettercap`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    expected = if OS.mac?
      "Operation not permitted"
    else
      "Permission Denied"
    end
    assert_match expected, shell_output("#{bin}/bettercap 2>&1", 1)
  end
end
