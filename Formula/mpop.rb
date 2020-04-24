class Mpop < Formula
  desc "POP3 client"
  homepage "https://marlam.de/mpop/"
  url "https://marlam.de/mpop/releases/mpop-1.4.9.tar.xz"
  sha256 "b820c4ad72dcf6dfa94d2f45042a713777b3b73895e737224ffe464a9aaf3642"

  bottle do
    sha256 "e2ccab956275d5eaf61ef8ec2645ccde0cfbfe3e84d59b42d86a29f0b565064b" => :catalina
    sha256 "7d131da5c86b9dd7ed471cea85343de18ef20a7d7d4bf653fe433e801d817a54" => :mojave
    sha256 "7f5fcd50154d66822876400e074918e31672585d046ec8a12907e9c4c8eb1b84" => :high_sierra
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
