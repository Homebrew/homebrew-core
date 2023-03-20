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
    sha256 arm64_ventura:  "c45e113cf07c6e3f5cdf643afef23374d3a0ecd3899eea218ada9643b01d6d66"
    sha256 arm64_monterey: "f8c7fa7a880578518afc49fa973c3c9fc3e7121777cc876034ebd27a34bdf4c4"
    sha256 arm64_big_sur:  "c2bc546882c16a954bc3e09534d73ba2aa72eefa1d727fb6b5e7317d456f1259"
    sha256 ventura:        "eb3a0f38944e7148d50db0ef6f304d1e486b796d11de913215e07ef9217f74c4"
    sha256 monterey:       "96950e483a62532a6f8245b9b2ed6e11ec0c3ceae8e3895f478af3e26034f845"
    sha256 big_sur:        "747b81fb47da9b632cc89036f5c8cb97b320244b819f8f89e50eb13a37c81e47"
    sha256 x86_64_linux:   "4795737ac58934f65fc775dc2d6ad5de4e895649a5be6e6656663811f7d28746"
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
