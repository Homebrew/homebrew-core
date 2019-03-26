class Apachetop < Formula
  desc "Top-like display of Apache log"
  homepage "https://web.archive.org/web/20170809160553/freecode.com/projects/apachetop"
  url "https://deb.debian.org/debian/pool/main/a/apachetop/apachetop_0.18.4.orig.tar.gz"
  sha256 "1cbbfd1bf12275fb21e0cb6068b9050b2fee8c276887054a015bf103a1ae9cc6"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f4520c12643b7b9d6afc80729217ecbe7f17298790dbe783e7909c436559ac30" => :mojave
    sha256 "e41dce58ad184e880c1f198ae1d5c0d0d1f1fc9fd27f1296a02a1b23e33c09cb" => :high_sierra
    sha256 "3a3f3b20db8183a8c642ce732d9ecc3eac68ea1c292cab0594c3d5000c181442" => :sierra
    sha256 "f1dd6f8ac7cb973228227b4cb678ef0bb61f618c482dc8d7d3144acccfebcf5b" => :el_capitan
    sha256 "1cfb399a8548e1ac48d7cb61374e23273aa1eb289e49ba452aa2c55641fe5bae" => :yosemite
    sha256 "78aa56c9141cfc658120edfb27e795cf178067d54f66c79fc752536d8e0335ea" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-logfile=/var/log/apache2/access_log"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/apachetop -h 2>&1", 1)
    assert_match "ApacheTop v#{version}", output
  end
end
