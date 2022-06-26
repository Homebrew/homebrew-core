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
    sha256 arm64_monterey: "49d124945bab950bde9c85f3db48bcef6424030329322194bf0b2e0698ba72c8"
    sha256 arm64_big_sur:  "1bf9fc2843e2909c2de3e326d20bbf7e7ca4a6e26b55218d804517c7f1aecfad"
    sha256 monterey:       "0c6266fba99f4b41aa524664d499bcc5729afdb745604176c742b6feea45a949"
    sha256 big_sur:        "06a0837a35cb89309a5e725e178db7de41711ae3a914a3136feb56576fa22c97"
    sha256 catalina:       "dc9a0bb669aca02fe3d4b5ba2375120c4056b2202b43e6988eb555fffc1a86bd"
    sha256 x86_64_linux:   "119d632c47f32b8f7ea9d7edfd6532d18c29302ae5a7f1d74f972bad9d8371ba"
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
