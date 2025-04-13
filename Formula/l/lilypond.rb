class Lilypond < Formula
  desc "Music engraving system"
  homepage "https://lilypond.org"
  url "https://lilypond.org/download/sources/v2.24/lilypond-2.24.4.tar.gz"
  sha256 "e96fa03571c79f20e1979653afabdbe4ee42765a3d9fd14953f0cd9eea51781c"
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
    rebuild 1
    sha256 arm64_sequoia: "186ccba4e185bdb0160e66bc68c4e70594d77b9d18a863718886667817b0f8b0"
    sha256 arm64_sonoma:  "80da0e56c2e27506e4a82b7cfcdfe9ca5e819ce2a52bc9c1cbdcc597557862db"
    sha256 arm64_ventura: "38a76fb76615646d4b43b6578d368fac8daee24834dc049ea0f50ffaeca73b33"
    sha256 sonoma:        "b31020b0176335c832d55556e5709b45b54ac04b2c0d04129d16a6a25ef8e6e7"
    sha256 ventura:       "a4112ff2f62a0b79a6de8ba3c34db2167d0076949ac617eeb81f9335dd461607"
    sha256 arm64_linux:   "23b8fdf9318178b066af933b4a82a96438d6a0096d368dd213544e13b9f67e50"
    sha256 x86_64_linux:  "d3bd2174c750e48ee24e19959f3587eaeaca0e155ba8d8dc973e3d43511d89d5"
  end

  head do
    url "https://gitlab.com/lilypond/lilypond.git", branch: "master"
    mirror "https://github.com/lilypond/lilypond.git"
    mirror "https://git.savannah.gnu.org/git/lilypond.git"

    depends_on "autoconf" => :build
    depends_on "make" => :build # make >= 4.2 is required
  end

  depends_on "bison" => :build # bison >= 2.4.1 is required
  depends_on "fontforge" => :build
  depends_on "pkgconf" => :build
  depends_on "t1utils" => :build
  depends_on "texinfo" => :build # makeinfo >= 6.1 is required
  depends_on "texlive" => :build
  depends_on "bdw-gc"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "glib"
  depends_on "guile"
  depends_on "pango"
  depends_on "python@3.13"

  uses_from_macos "flex" => :build
  uses_from_macos "perl" => :build

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "gettext" => :build
  end

  resource "font-urw-base35" do
    url "https://github.com/ArtifexSoftware/urw-base35-fonts/archive/refs/tags/20200910.tar.gz"
    sha256 "e0d9b7f11885fdfdc4987f06b2aa0565ad2a4af52b22e5ebf79e1a98abd0ae2f"
  end

  def install
    system "./autogen.sh", "--noconfigure" if build.head?

    system "./configure", "--datadir=#{share}",
                          "--disable-documentation",
                          *("--with-flexlexer-dir=#{Formula["flex"].include}" if OS.linux?),
                          "GUILE_FLAVOR=guile-3.0",
                          *std_configure_args

    system "make"
    system "make", "install"

    system "make", "bytecode"
    system "make", "install-bytecode"

    elisp.install share.glob("emacs/site-lisp/*.el")

    fonts = pkgshare/(build.head? ? File.read("out/VERSION").chomp : version)/"fonts/otf"

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
    assert_path_exists testpath/"test.pdf"

    output = shell_output("#{bin}/lilypond --define-default=show-available-fonts 2>&1")
             .encode("UTF-8", invalid: :replace, replace: "\ufffd")
    common_styles = ["Regular", "Bold", "Italic", "Bold Italic"]
    {
      "C059"            => ["Roman", *common_styles[1..]],
      "Nimbus Mono PS"  => common_styles,
      "Nimbus Sans"     => common_styles,
      "TeX Gyre Cursor" => common_styles,
      "TeX Gyre Heros"  => common_styles,
      "TeX Gyre Schola" => common_styles,
    }.each do |family, styles|
      styles.each do |style|
        assert_match(/^\s*#{family}:style=#{style}$/, output)
      end
    end
  end
end
