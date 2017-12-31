class Pianod < Formula
  desc "Pandora client with multiple control interfaces"
  homepage "https://deviousfish.com/pianod/"
  url "https://deviousfish.com/Downloads/pianod/pianod-176.tar.gz"
  sha256 "4f3be12daef1adb3bcbbcf8ec529abf0ac018e03140be9c5b0f1203d6e1b9bf0"

  bottle do
    sha256 "e5a1241330f79eb7563193c1f07ecddef1768e03e9b267a551f2d55e2e18dc1f" => :high_sierra
    sha256 "2414a7a28c854c54a905e0f00d67e7a23bff75aba25484acab508359fb1a88a2" => :sierra
    sha256 "51a34cb2a818ee303a9c785d2b4a25abdc5355fd7c2c4812eee4f831e55a46d2" => :el_capitan
  end

  depends_on "pkg-config" => :build

  depends_on "libao"
  depends_on "libgcrypt"
  depends_on "gnutls"
  depends_on "json-c"
  depends_on "faad2" => :recommended
  depends_on "mad" => :recommended

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/pianod", "-v"
  end
end
