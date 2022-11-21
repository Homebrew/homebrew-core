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
    rebuild 1
    sha256 arm64_ventura:  "ce6c92b231356bae757f2ee4d3df6e0ca42f869d4b66058294b66e04bdba7488"
    sha256 arm64_monterey: "90d9c931ef38b4f20bfc1228b753fe00e563e45f02c22b4aca1e59b802594c06"
    sha256 arm64_big_sur:  "2d02e4a99bfe749ae2ab24976f015ec1a38db76aa55146f441575dda15a0d2bd"
    sha256 ventura:        "e9b7cb2f475610a72a818c9007da47c805a485079caff1af676dbc256e76db4c"
    sha256 monterey:       "55c985abb54a13e8dfaab1bbf0deb6f5fdb6c960a7147e5c99134c7e763b6837"
    sha256 big_sur:        "634c7aec2ac85a6fe1e04099e0b92b54e7fac31c2a586e9ca270403ddcd7d1a9"
    sha256 catalina:       "fb23cd0100e20cdcc2de2333e8f470b3a1cd354322a7bcd257b37682c7ef4727"
    sha256 x86_64_linux:   "1b351578a95058c9fab5f774a44ec960daf27ed498ac0546235c30da6b698fbe"
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
  depends_on "python@3.11"

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
