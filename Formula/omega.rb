class Omega < Formula
  desc "Packaged search engine for websites, built on top of Xapian"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.21/xapian-omega-1.4.21.tar.xz"
  sha256 "88a113c5598fc95833e1212c70be463abb9d5601564d21b861636f737955aad5"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://xapian.org/download"
    regex(/href=.*?xapian-omega[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "d53c564d61ee83d764b52f502565344ff083b5c0a6d931674b351957da61736e"
    sha256 arm64_big_sur:  "f62b0e919856934256de998c0548b6bd93cf0e269196cd80e36dbefac895c46f"
    sha256 monterey:       "da8c5e4432ad04fd0ceb16dd24202e61c7730622c73a66a13aceffec69b40462"
    sha256 big_sur:        "f30d69271aec6688ddf5c1ebd8deebb441b7618f3f70a0c5f9afc54b7f3a657d"
    sha256 catalina:       "b55e1518a7e54cb9a1867c1d0b518fa6e580a874df4af5e668f6d190148b4cda"
    sha256 x86_64_linux:   "5d8aca48a199854856e468f06de62c67c5b280cef8e3123a1d4b46ed425550ed"
  end

  depends_on "pkg-config" => :build
  depends_on "libmagic"
  depends_on "pcre2"
  depends_on "xapian"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/omindex", "--db", "./test", "--url", "/", "#{share}/doc/xapian-omega"
    assert_predicate testpath/"./test/flintlock", :exist?
  end
end
