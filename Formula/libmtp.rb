class Libmtp < Formula
  desc "Implementation of Microsoft's Media Transfer Protocol (MTP)"
  homepage "https://libmtp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/libmtp/libmtp/1.1.15/libmtp-1.1.15.tar.gz"
  sha256 "d040900b46757e311b1fb3bfa8c05db09c8b6811e044bce8c88c9f3f6d3a3021"

  bottle do
    cellar :any
    sha256 "7eddb5328ad0c361cc1458fc42f04296a4da0d58f75f86c121bfbebd1fd8ead7" => :mojave
    sha256 "a72d40dc60cea24e65a17ec6b617776522442a07a18e4bd562a240f3596d9090" => :high_sierra
    sha256 "93a46eef872afe4cc3b784d7c7448d2780fe463c5a80a529e12fd7466e0a58a4" => :sierra
    sha256 "752d53d11b32a60717d6398c564beeebe2f70eae06d19222e2874e15bde8351b" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libusb-compat"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-mtpz"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mtp-getfile")
  end
end
