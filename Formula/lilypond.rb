class Lilypond < Formula
  desc "Music notation for everyone"
  homepage "https://lilypond.org"
  url "https://lilypond.org/download/sources/v2.22/lilypond-2.22.1.tar.gz"
  sha256 "72ac2d54c310c3141c0b782d4e0bef9002d5519cf46632759b1f03ef6969cc30"
  license "GPL-3.0-or-later"

  revision 1

  depends_on "autoconf" => :build
  depends_on "bison" => :build # because macOS version is not supported
  depends_on "dblatex" => :build
  depends_on "extractpdfmark" => :build
  depends_on "fontconfig" => :build
  depends_on "fontforge" => :build
  depends_on "freetype" => :build
  depends_on "gettext" => :build
  depends_on "ghostscript" => :build
  depends_on "glib" => :build
  depends_on "guile@2" => :build
  depends_on "imagemagick" => :build
  depends_on "make" => :build
  depends_on "pango" => :build
  depends_on "pkg-config" => :build
  depends_on "t1utils" => :build
  depends_on "texi2html" => :build
  depends_on "texinfo" => :build # because macOS version is not supported

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "guile@2"
  depends_on :macos
  depends_on "pango"
  depends_on "python@3.9"

  uses_from_macos "flex" => :build

  resource "font-urw" do
    url "https://github.com/ArtifexSoftware/urw-base35-fonts/archive/20200910.tar.gz".sub(/tar\.gz$/, "zip")
    sha256 "66eed7ca2dfbf44665aa34cb80559f4a90807d46858ccf76c34f9ac1701cfa27"
  end

  resource "tex-resources" do 
    url "https://github.com/jsfelix/homebrew-core/releases/download/v2.22.1/tex-resources.tar.gz"
    sha256 "b662ee0fc506bdeae6ed8cfebface09337d27fa06203f2f9c862e26b63f93490"
  end

  def install
    system "./autogen.sh", "--noconfigure"

    inreplace "config.make.in",
      %r{^\s*elispdir\s*=\s*\$\(datadir\)/emacs/site-lisp\s*$},
      "elispdir = $(datadir)/emacs/site-lisp/lilypond"

    mkdir "build" do
      resource("font-urw").stage buildpath/"urw"

      resource("tex-resources").stage buildpath/"tex-resources"

      ENV.append_path "PATH", "#{buildpath}/tex-resources/bin/universal-darwin"

      system "../configure",
             "--prefix=#{prefix}",
             "--with-texgyre-dir=#{buildpath}/tex-resources/texmf-dist/fonts/opentype/public/tex-gyre",
             "--with-urwotf-dir=#{buildpath}/urw/fonts",
             "--disable-documentation"

      ENV.prepend_path "LTDL_LIBRARY_PATH", Formula["guile@2"].lib

      system "make"
      system "make", "install"
    end
  end

  test do
    system bin/"lilypond", "--version"
  end
end
