class Lilypond < Formula
  desc "Music notation for everyone"
  homepage "https://lilypond.org"
  url "https://lilypond.org/download/sources/v2.22/lilypond-2.22.1.tar.gz"
  sha256 "72ac2d54c310c3141c0b782d4e0bef9002d5519cf46632759b1f03ef6969cc30"
  license "GPL-3.0-or-later"

  depends_on "autoconf" => :build
  depends_on "fontforge" => :build
  depends_on "gettext" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkg-config" => :build
  depends_on "t1utils" => :build
  depends_on "texi2html" => :build

  depends_on arch: :x86_64

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "guile@2"
  depends_on :macos
  depends_on "pango"
  depends_on "python@3.9"

  uses_from_macos "flex" => :build
  uses_from_macos "m4" => :build

  resource "bison" do
    url "https://ftp.gnu.org/gnu/bison/bison-3.7.6.tar.xz"
    sha256 "67d68ce1e22192050525643fc0a7a22297576682bef6a5c51446903f5aeef3cf"
  end

  resource "font-urw" do
    url "https://github.com/ArtifexSoftware/urw-base35-fonts/archive/20200910.tar.gz"
    sha256 "e0d9b7f11885fdfdc4987f06b2aa0565ad2a4af52b22e5ebf79e1a98abd0ae2f"
  end

  resource "texinfo" do
    url "https://ftp.gnu.org/gnu/texinfo/texinfo-6.8.tar.xz"
    sha256 "8eb753ed28bca21f8f56c1a180362aed789229bd62fff58bf8368e9beb59fec4"
  end

  resource "tex-build-dep" do
    url "https://github.com/jsfelix/homebrew-core/releases/download/v2.22.1/tex-build-dep.tar.gz"
    sha256 "18132bb70b109c6d0399095bc0acaf2616bf9edbd401af4a966eb3807b47797a"
  end

  def install
    resource("bison").stage buildpath/"bison"
    cd "bison" do
      system "./configure", "--disable-dependency-tracking",
                          "--enable-relocatable",
                          "--prefix=/out"
      system "make", "install", "DESTDIR=#{buildpath}/bison"
    end

    resource("texinfo").stage buildpath/"texinfo"
    cd "texinfo" do
      system "./configure", "--disable-dependency-tracking",
                          "--disable-install-warnings",
                          "--prefix=#{buildpath}/texinfo/out"
      system "make", "install"
    end

    system "./autogen.sh", "--noconfigure"

    inreplace "config.make.in",
      %r{^\s*elispdir\s*=\s*\$\(datadir\)/emacs/site-lisp\s*$},
      "elispdir = $(datadir)/emacs/site-lisp/lilypond"

    mkdir "build" do
      resource("font-urw").stage buildpath/"urw"

      resource("tex-build-dep").stage buildpath/"tex-build-dep"

      ENV.prepend_path "PATH", "#{buildpath}/bison/out/bin"
      ENV.prepend_path "PATH", "#{buildpath}/texinfo/out/bin"
      ENV.prepend_path "PATH", "#{buildpath}/tex-build-dep/bin/universal-darwin"

      system "../configure",
             "--prefix=#{prefix}",
             "--with-texgyre-dir=#{buildpath}/tex-build-dep/texmf-dist/fonts/opentype/public/tex-gyre",
             "--with-urwotf-dir=#{buildpath}/urw/fonts",
             "--disable-documentation"

      ENV.prepend_path "LTDL_LIBRARY_PATH", Formula["guile@2"].lib

      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.ly").write "\\relative { c' d e f g a b c }"
    system bin/"lilypond", "--loglevel=ERROR", "test.ly"
    assert_predicate testpath/"test.pdf", :exist?
  end
end
