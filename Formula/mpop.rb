class Mpop < Formula
  desc "POP3 client"
  homepage "https://marlam.de/mpop/"
  url "https://marlam.de/mpop/releases/mpop-1.4.7.tar.xz"
  sha256 "d3f6225bbaaca1c352aa7fab0d5de2a2f0ac3d1586ecd9dfb924df649d2ad630"

  bottle do
    sha256 "e1e49451607c9f43c5d25be5f84959d89f0037bac6b579760af425052d36e442" => :catalina
    sha256 "cae5ba211272387489bd78abb54c0173ce692d393f5e87af7a7f3b1653e9f8cc" => :mojave
    sha256 "c532568b1ed5d21d145f0bfe641c795240fa7a9dd061bc3216dfd1e8b3029836" => :high_sierra
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
