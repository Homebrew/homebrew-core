class Dvisvgm < Formula
  desc "Fast DVI to SVG converter"
  homepage "https://dvisvgm.de"
  url "https://github.com/mgieseki/dvisvgm/releases/download/3.5/dvisvgm-3.5.tar.gz"
  sha256 "41ea2e10fe6bdc4ce7672519cfc2998e5c30c8b29fbcd8901915c7dac7fa494c"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "brotli"
  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "potrace"
  depends_on "texlive"
  depends_on "woff2"

  uses_from_macos "zlib"

  def install
    args = [
      "--disable-silent-rules",
      "--with-texlive=#{Formula["texlive"].opt_prefix}",
    ]
    args << "--with-zlib=#{Formula["zlib"].opt_prefix}" if OS.linux?

    system "./configure", *args, *std_configure_args
    # Optional: "--with-ttfautohint" if ttfautohint is a dependency
    system "make"
    system "make", "install"

    # Avoid references to the Homebrew shims directory
    inreplace "share/dvisvgm/data/Makefile", Superenv.shims_path/ENV.cc, ENV.cc

    # Install test data files for use in tests
    pkgshare.install "tests/data"
  end

  test do
    # Use the sample DVI file from the installed test data
    sample_dvi = pkgshare/"data/sample.dvi"
    cp sample_dvi, testpath/"sample.dvi"
    assert_path_exists testpath/"sample.dvi"

    # Test basic functionality of dvisvgm
    output = shell_output("#{bin}/dvisvgm --version")
    assert_match "dvisvgm", output

    # Convert DVI to SVG
    system bin/"dvisvgm", "--no-fonts", "sample.dvi"
    assert_path_exists testpath/"sample.svg"

    # Verify SVG content
    svg_content = File.read(testpath/"sample.svg")
    assert_match(/<svg/, svg_content)
  end
end
