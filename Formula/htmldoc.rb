class Htmldoc < Formula
  desc "Convert HTML to PDF or PostScript"
  homepage "https://www.msweet.org/htmldoc/"
  url "https://github.com/michaelrsweet/htmldoc/archive/v1.9.15.tar.gz"
  sha256 "9dc88e5a2ce849105933c438bbe54f4383f0d1dadb494f52c6ec941317659431"
  license "GPL-2.0-only"
  head "https://github.com/michaelrsweet/htmldoc.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "39479bbbf19a5a2c35320aa410690830862ddc48f35c47b15a6f8e0388859765"
    sha256 arm64_big_sur:  "1e9132616e07ca6999ddb9d6bb9b8456969b27e15e228bebfeca44dc05f34711"
    sha256 monterey:       "9cbc78f597a80f0e2807cbf299b1a0cbb17d06cd27fa55697ae6ed8e1e5a132b"
    sha256 big_sur:        "c4f86d41cf26e314deb251bde3a59cbaefcc15077b4fb365e8aa9e5b57723f33"
    sha256 catalina:       "e0b03ef14f3c9ffa4ba04434f8cad7fa9646f701b633455b623312a57765fc10"
    sha256 x86_64_linux:   "ce5c9fcc2a61dfb9784e7c60ab9cc9211ce0bec0b5f71537ccdf4bdbd59f2fd2"
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
