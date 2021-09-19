class Mpop < Formula
  desc "POP3 client"
  homepage "https://marlam.de/mpop/"
  url "https://marlam.de/mpop/releases/mpop-1.4.14.tar.xz"
  sha256 "2844c265d7d0575ba0057fbcf8c68e3701ed8000ccccc8538ba4f8bce95bdc10"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://marlam.de/mpop/download/"
    regex(/href=.*?mpop[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "ffa7d1d7240b1fe9913f3f7f104cf410325e3e15de646cfc7d508db65c7a4288"
    sha256 big_sur:       "4b8ef4bdfbc2eb722f2c0698207f4b8380efe396bb2dde01ee9ab15905c77961"
    sha256 catalina:      "47eb7901c79b0c2c0110d0d536851af477ff5626a8a46a8ba2fc1551ea790a7c"
    sha256 mojave:        "afaf7fa8399df4285ec412ba7b89f0d19bcbc21fad7029dfb7ae5092c0af8efb"
    sha256 x86_64_linux:  "0813016d1ca4ea0dbc41c22a58cc675cc6723b87fc0374f6228434277ff3403f"
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mpop --version")
  end
end
