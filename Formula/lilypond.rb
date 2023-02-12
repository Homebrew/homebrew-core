class Lilypond < Formula
  desc "Music engraving system"
  homepage "https://lilypond.org"
  url "https://lilypond.org/download/sources/v2.24/lilypond-2.24.1.tar.gz"
  sha256 "d5c59087564a5cd6f08a52ba80e7d6509b91c585e44385dcc0fa39265d181509"
  license all_of: [
    "GPL-3.0-or-later",
    "GPL-3.0-only",
    "OFL-1.1-RFN",
    "GFDL-1.3-no-invariants-or-later",
    :public_domain,
    "MIT",
    "AGPL-3.0-only",
    "LPPL-1.3c",
  ]

  livecheck do
    url "https://lilypond.org/source.html"
    regex(/href=.*?lilypond[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "c8241845c55c18951523f4e96258281f1b5539981c33c222a1cff885f62a012f"
    sha256 arm64_monterey: "59441cf679a019b3d6cbbfce5b87bfbae081e193ff45f5b8be0afb95614e120c"
    sha256 arm64_big_sur:  "ce9b57df1ff009212994a0277527e96ffa0eaee192d5e07630f9aec5f4d0ea29"
    sha256 ventura:        "5e379accb12daa34dab8cf690cf48514c35a6c0f5890b507051d65a194913188"
    sha256 monterey:       "7cae5b84cc6d6ebd524345ae218ac48f384e06e0fd1e3c3868523386ddd67f04"
    sha256 big_sur:        "af9e52e3270014d40863f9a3cbf6824be28367d5f6c758ed43faa1d0c917fd20"
    sha256 x86_64_linux:   "e9e6311a81d7d1351ee75db814b4e5e997b48a27e05165b56029a7417d4e07ff"
  end

  head do
    url "https://gitlab.com/lilypond/lilypond.git", branch: "master"

    depends_on "autoconf" => :build
  end

  depends_on "bison" => :build # bison >= 2.4.1 is required
  depends_on "fontforge" => :build
  depends_on "gettext" => :build
  depends_on "libpthread-stubs" => :build
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

  resource "font-urw-base35" do
    url "https://github.com/ArtifexSoftware/urw-base35-fonts/archive/refs/tags/20200910.tar.gz"
    sha256 "e0d9b7f11885fdfdc4987f06b2aa0565ad2a4af52b22e5ebf79e1a98abd0ae2f"
  end

  def install
    system "./autogen.sh", "--noconfigure" if build.head?

    system "./configure", "--datadir=#{share}",
                          "--disable-documentation",
                          "--with-flexlexer-dir=#{Formula["flex"].include}",
                          "GUILE_FLAVOR=guile-3.0",
                          *std_configure_args

    system "make"
    system "make", "install"

    system "make", "bytecode"
    system "make", "install-bytecode"

    elisp.install share.glob("emacs/site-lisp/*.el")

    fonts = pkgshare/version/"fonts/otf"

    resource("font-urw-base35").stage do
      ["C059", "NimbusMonoPS", "NimbusSans"].each do |name|
        Dir["fonts/#{name}-*.otf"].each do |font|
          fonts.install font
        end
      end
    end

    ["cursor", "heros", "schola"].each do |name|
      cp Dir[Formula["texlive"].share/"texmf-dist/fonts/opentype/public/tex-gyre/texgyre#{name}-*.otf"], fonts
    end
  end

  test do
    (testpath/"test.ly").write "\\relative { c' d e f g a b c }"
    system bin/"lilypond", "--loglevel=ERROR", "test.ly"
    assert_predicate testpath/"test.pdf", :exist?

    output = shell_output("#{bin}/lilypond --define-default=show-available-fonts 2>&1")
    output = output.encode("UTF-8", invalid: :replace, replace: "")
    fonts = {
      "C059"            => ["Roman", "Bold", "Italic", "Bold Italic"],
      "Nimbus Mono PS"  => ["Regular", "Bold", "Italic", "Bold Italic"],
      "Nimbus Sans"     => ["Regular", "Bold", "Italic", "Bold Italic"],
      "TeX Gyre Cursor" => ["Regular", "Bold", "Italic", "Bold Italic"],
      "TeX Gyre Heros"  => ["Regular", "Bold", "Italic", "Bold Italic"],
      "TeX Gyre Schola" => ["Regular", "Bold", "Italic", "Bold Italic"],
    }
    fonts.each do |family, styles|
      styles.each do |style|
        assert_match(/^\s*#{family}:style=#{style}$/, output)
      end
    end
  end
end
