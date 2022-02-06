class Htmldoc < Formula
  desc "Convert HTML to PDF or PostScript"
  homepage "https://www.msweet.org/htmldoc/"
  url "https://github.com/michaelrsweet/htmldoc/archive/v1.9.15.tar.gz"
  sha256 "9dc88e5a2ce849105933c438bbe54f4383f0d1dadb494f52c6ec941317659431"
  license "GPL-2.0-only"
  head "https://github.com/michaelrsweet/htmldoc.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "5201fd66f2c70687125cfd21df27d5b41b9501759531575a853af014aed12174"
    sha256 arm64_big_sur:  "7114553b8506397af912204d2a7d8cab2ebc174b97eef6685a92029cce9b3e93"
    sha256 monterey:       "23361b444c63df5c66c95c0026305dee37cac9ae0c98c3ab8b31ac7c70c919c4"
    sha256 big_sur:        "c1faf9d3df6c5e695b3b07f4969d91a03724ccf0214310ed5218f4f7699b4d57"
    sha256 catalina:       "0b8010969e640770e907f36341c2efb7bbe3606849c39912b9cf0a2439a41ff5"
    sha256 x86_64_linux:   "e02710e0981b9eadab0f85844e05efedae6da1ae5a58bdac4ffb425d22fb249f"
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libpng"

  def install
    system "./configure", "--disable-debug",
                          "--disable-ssl",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/htmldoc", "--version"
  end
end
