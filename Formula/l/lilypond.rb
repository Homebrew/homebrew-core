class Lilypond < Formula
  desc "Music engraving system"
  homepage "https://lilypond.org"
  url "https://lilypond.org/download/sources/v2.26/lilypond-2.26.0.tar.gz"
  sha256 "bbe82dbeba7f7f99ddcd8d1fa134a0d89cafa6e8f815fde5bb01f4208b06fe05"
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
    sha256 arm64_tahoe:   "3105d0c645967f0405173d0521d258fb88b6f95d4154547d4b71df72470831d9"
    sha256 arm64_sequoia: "1f4389b9f3a425d7c54b6de2b83966bfcc89cbcb9c0e2652361da84ee247d952"
    sha256 arm64_sonoma:  "607a9d68b9032c97b8a7e3aaf8798002732e00d80f4e86d3fdb2e5049b6beb1f"
    sha256 sonoma:        "76d49d11c62ee6443fb82e5011ad3939942ba91863aee07cd62759d37a97570b"
    sha256 arm64_linux:   "fc9bf54f0e144441e031ff5c956ac7fc0e4f454ad4d6648a3a733c6b1ca87169"
    sha256 x86_64_linux:  "7e8c8a433ddc32619b5b828c37f94400a5a586be4da50cb3f410615cb42ef4b8"
  end

  head do
    url "https://gitlab.com/lilypond/lilypond.git", branch: "master"
    mirror "https://github.com/lilypond/lilypond.git"
    mirror "https://git.savannah.gnu.org/git/lilypond.git"

    depends_on "autoconf" => :build
  end

  depends_on "bison" => :build # bison >= 2.4.1 is required
  depends_on "fontforge" => :build
  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "t1utils" => :build
  depends_on "texinfo" => :build # makeinfo >= 6.1 is required
  depends_on "texlive" => :build
  depends_on "bdw-gc"
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "glib"
  depends_on "guile"
  depends_on "libpng"
  depends_on "pango"
  depends_on "python@3.14"

  uses_from_macos "flex" => :build
  uses_from_macos "perl" => :build

  on_macos do
    depends_on "make" => :build # make >= 4.2 is required
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "zlib-ng-compat"
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
                          *std_configure_args

    system "make"
    system "make", "install"

    system "make", "bytecode"
    system "make", "install-bytecode"

    elisp.install share.glob("emacs/site-lisp/*.el")

    fonts = pkgshare/File.read("out/VERSION").chomp/"fonts/otf"

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

    output = shell_output("#{bin}/lilypond --define-default=show-available-fonts")
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
