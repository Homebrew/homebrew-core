class Lilypond < Formula
  desc "Music engraving system"
  homepage "https://lilypond.org"
  url "https://lilypond.org/download/sources/v2.24/lilypond-2.24.0.tar.gz"
  sha256 "3cedbe3b92b02569e3a6f2f0674858967b3da278d70aa3e98aef5bdcd7f78b69"
  license all_of: [
    "GPL-3.0-or-later",
    "GPL-3.0-only",
    "OFL-1.1-RFN",
    "GFDL-1.3-no-invariants-or-later",
    :public_domain,
    "MIT",
  ]

  livecheck do
    url "https://lilypond.org/source.html"
    regex(/href=.*?lilypond[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "8b75d616d053954f52420a608e3fe40756fb4c987ca85601e3339b6ef1b3e40e"
    sha256 arm64_monterey: "9eb2ad5a3edef407451fc47b02e507e74849ccc805e7926fd1b7b1e6d62ee230"
    sha256 arm64_big_sur:  "57a16379b2dd9290894eae10ab88f7b4eed12f5af2145311436e19e827142101"
    sha256 ventura:        "1495d0ad341340b67b0a6ec179b80d62cb29e0635c56b80e4798ae61778771a4"
    sha256 monterey:       "9af1797f65d330b0624e786f9bc47bd6f47653581f7a0ebd8fa37ef025a4ca55"
    sha256 big_sur:        "bcc12cfa0a1959a2d38514e843de20ffd54d82c4f86f2a0da00d682e6c0aa1c9"
    sha256 x86_64_linux:   "4c90e984dec560d2ea318351f301b5a40b20182514c31c7d34d9e4acbed105fa"
  end

  head do
    url "https://gitlab.com/lilypond/lilypond.git", branch: "master"

    depends_on "autoconf" => :build
  end

  depends_on "bison" => :build # bison >= 2.4.1 is required
  depends_on "fontforge" => :build
  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "t1utils" => :build
  depends_on "texinfo" => :build # makeinfo >= 6.1 is required
  depends_on "texlive" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "guile"
  depends_on "pango"
  depends_on "python@3.11"

  uses_from_macos "flex" => :build
  uses_from_macos "perl" => :build

  def install
    system "./autogen.sh", "--noconfigure" if build.head?

    system "./configure", "--datadir=#{share}",
                          "--disable-documentation",
                          *std_configure_args,
                          "--with-flexlexer-dir=#{Formula["flex"].include}",
                          "GUILE_FLAVOR=guile-3.0"

    system "make"
    system "make", "install"

    system "make", "bytecode"
    system "make", "install-bytecode"

    elisp.install share.glob("emacs/site-lisp/*.el")
  end

  test do
    (testpath/"test.ly").write "\\relative { c' d e f g a b c }"
    system bin/"lilypond", "--loglevel=ERROR", "test.ly"
    assert_predicate testpath/"test.pdf", :exist?
  end
end
