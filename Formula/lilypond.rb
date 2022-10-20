class Lilypond < Formula
  desc "Music engraving program"
  homepage "https://lilypond.org"
  license all_of: [
    "GPL-3.0-or-later",
    "GPL-3.0-only",
    "OFL-1.1-RFN",
    "GFDL-1.3-no-invariants-or-later",
    :public_domain,
    "MIT",
  ]
  revision 1

  stable do
    url "https://lilypond.org/download/sources/v2.22/lilypond-2.22.2.tar.gz"
    sha256 "dde90854fa7de1012f4e1304a68617aea9ab322932ec0ce76984f60d26aa23be"

    # Shows LilyPond's Guile version (Homebrew uses v2, other builds use v1).
    # See https://gitlab.com/lilypond/lilypond/-/merge_requests/950
    patch do
      url "https://gitlab.com/lilypond/lilypond/-/commit/a6742d0aadb6ad4999dddd3b07862fe720fe4dbf.diff"
      sha256 "2a3066c8ef90d5e92b1238ffb273a19920632b7855229810d472e2199035024a"
    end
  end

  livecheck do
    url "https://lilypond.org/source.html"
    regex(/href=.*?lilypond[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "42d9e24c8ff290b790e9fc1bd498de92714dea3974522fb80e9a1f5873651116"
    sha256 arm64_big_sur:  "a3e8921348a09a2c6effd6b9e36397c834d564371cfa5fdbe65733c2975a6673"
    sha256 monterey:       "21e65b1b54833b521171096e141af20fa1b2eb3e335a91283ef94a1d7e47854d"
    sha256 big_sur:        "f903f32936b52a9650a84451801a5f1dab1a13266e9bb11409654fd1fa65e406"
    sha256 catalina:       "b364827c6ff8e36c08ce2be6bc1b98e1f36b2ecce915e27a73f326332785c2ff"
    sha256 x86_64_linux:   "03dc525eddfe9e67d9818e2d68543aff8770d13bc0e8ae0dfcd54c6f8905401c"
  end

  head do
    url "https://git.savannah.gnu.org/git/lilypond.git", branch: "master"
    mirror "https://github.com/lilypond/lilypond.git"

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
  depends_on "guile@2"
  depends_on "pango"
  depends_on "python@3.10"

  uses_from_macos "flex" => :build
  uses_from_macos "perl" => :build

  def install
    system "./autogen.sh", "--noconfigure" if build.head?

    texgyre_dir = "#{Formula["texlive"].opt_share}/texmf-dist/fonts/opentype/public/tex-gyre"
    system "./configure", "--prefix=#{prefix}",
                          "--datadir=#{share}",
                          "--with-texgyre-dir=#{texgyre_dir}",
                          "--disable-documentation"

    ENV.prepend_path "LTDL_LIBRARY_PATH", Formula["guile@2"].opt_lib
    system "make"
    system "make", "install"

    elisp.install share.glob("emacs/site-lisp/*.el")

    libexec.install bin/"lilypond"

    (bin/"lilypond").write_env_script libexec/"lilypond",
      GUILE_WARN_DEPRECATED: "no",
      LTDL_LIBRARY_PATH:     "#{Formula["guile@2"].opt_lib}:$LTDL_LIBRARY_PATH"
  end

  test do
    (testpath/"test.ly").write "\\relative { c' d e f g a b c }"
    system bin/"lilypond", "--loglevel=ERROR", "test.ly"
    assert_predicate testpath/"test.pdf", :exist?
  end
end
