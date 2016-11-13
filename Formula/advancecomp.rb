class Advancecomp < Formula
  desc "Recompression utilities for .PNG, .MNG, .ZIP, and .GZ files"
  homepage "http://www.advancemame.it/comp-readme.html"
  url "https://github.com/amadvance/advancecomp/archive/v1.22.tar.gz"
  sha256 "b8c482027a5f78d9a7f871cbba19cc896ed61653d1d93034c9dbe55484952605"

  bottle do
    cellar :any_skip_relocation
    sha256 "57efdb6a3c25ecbeb8148534a5c28f28be49c6291e67d5d28a307edd81e0d71b" => :sierra
    sha256 "35b6ce1470c8c258b3e4e781ff14d202ed9754f82a244deacb73a1e1edddbd42" => :el_capitan
    sha256 "cc34ceddf0fb8162176236aaae1f75f1d48ad805588c7f8ae608196d37223c20" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--enable-bzip2", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system bin/"advdef", "--version"
    system bin/"advpng", "--version"
  end
end
