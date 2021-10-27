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
    url "https://lilypond.org/download/sources/v2.22/lilypond-2.22.1.tar.gz"
    sha256 "72ac2d54c310c3141c0b782d4e0bef9002d5519cf46632759b1f03ef6969cc30"

    # Distinguishes Lilypond homebrew installation that uses Guile 2.2 while
    # others use Guile 1.8.
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
    sha256 arm64_big_sur: "5b5182726f7fd17fc1da720d48d093b326c3b0e60ef7f8a56598d6d142999871"
    sha256 big_sur:       "c6d72cd49f4ea86f978d257a2e6f73f6df79f5bddaadb1c8e676e2e715fe3d5d"
    sha256 catalina:      "d38a77136b4bd19124aa9a01bd2de4a8fedbc2b9fea9e7e6d8addb9f2a09b90d"
    sha256 mojave:        "2fed3245ffd0ad5ad6c17ecd9512ddbd117efcde703bd40732d8b820f9185503"
    sha256 x86_64_linux:  "cb3d3205f0526ad3182d2afd32fa28a94ec0b893a39fff466ef7372335a15b52"
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
  depends_on "python@3.9"

  uses_from_macos "flex" => :build
  uses_from_macos "perl" => :build

  def install
    system "./autogen.sh", "--noconfigure" if build.head?
    system "./configure",
            "--prefix=#{prefix}",
            "--datadir=#{share}",
            "--with-texgyre-dir=#{Formula["texlive"].opt_share}/texmf-dist/fonts/opentype/public/tex-gyre",
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
