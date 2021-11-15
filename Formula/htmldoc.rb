class Htmldoc < Formula
  desc "Convert HTML to PDF or PostScript"
  homepage "https://www.msweet.org/htmldoc/"
  url "https://github.com/michaelrsweet/htmldoc/archive/v1.9.13.tar.gz"
  sha256 "e020936267afe2c36d9cecd96a054994947207cbe231c94f59c98e08ca24dd37"
  license "GPL-2.0-only"
  head "https://github.com/michaelrsweet/htmldoc.git"

  bottle do
    sha256 arm64_monterey: "4eaaa2e07a9790dbbd7056dee92f970d96285e37b82ade49710327f9cdb7cdb8"
    sha256 arm64_big_sur:  "f5b0c96b9741d286d8acb68f6eeaffc60a36a921f9d247332b3d18374f65aa28"
    sha256 monterey:       "3fef14e4afee4d7060a99e4e476cc28c402b804f868b347eafb24a651e19f264"
    sha256 big_sur:        "b81de434d2fc905d8d3cf593b99e3b5bb4d20f0d48f4ecef09b8675c3fb15fc6"
    sha256 catalina:       "15247e61f5a3e4d78f0028c7cc57d34251450263c09bde31bc999ca2f3144a33"
    sha256 x86_64_linux:   "0087b0c9a4735fabe9d8bd1c02fb0472ab8f22a28161deb1e27fef1ae381aea6"
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
