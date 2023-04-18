class Pngcheck < Formula
  desc "Print info and check PNG, JNG, and MNG files"
  homepage "http://www.libpng.org/pub/png/apps/pngcheck.html"
  url "http://www.libpng.org/pub/png/src/pngcheck-3.0.3.tar.gz"
  sha256 "c36a4491634af751f7798ea421321642f9590faa032eccb0dd5fb4533609dee6"
  license all_of: ["MIT", "GPL-2.0-or-later"]

  livecheck do
    url :homepage
    regex(/href=.*?pngcheck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2bf9bb55a086b248952b1c262fe8f97dbd69b59fa01009775003867a2a891262"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25f8462c7bd187f4fca2429f6844652ba6f1cc18143028fdf3fdb2ca98afd8aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a009523aaa8a5c8eb879fda99829ce1007b682b2caa2413af78112aa94ee741c"
    sha256 cellar: :any_skip_relocation, ventura:        "37dda1d112b78ff92c0af09a33a582645d3648019501f44ce3f76989b801777f"
    sha256 cellar: :any_skip_relocation, monterey:       "c5d47d9ee6ecfe6704d146c78531ad34c42e62a43a0bbfd0adc01e6a570d5a65"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a025005cde9e8423606279cea498d921810f2334fe17a7bf23a1eba6ee54aef"
    sha256 cellar: :any_skip_relocation, catalina:       "a4256bacc1a8025fa298b35d93af3ecf213449ab9118106530cdd29455293ead"
    sha256 cellar: :any_skip_relocation, mojave:         "6423830817d3166ce48ea9cb88f3a83f1f7e381d8a1039c4db153e465450d5c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bee1eb579044cbdf33c6e4f045a800debb49b2f9ca4d3517d718956872a58a97"
  end

  uses_from_macos "zlib"

  def install
    system "make", "-f", "Makefile.unx", "ZINC=", "ZLIB=-lz"
    bin.install %w[pngcheck pngsplit png-fix-IDAT-windowsize]
  end

  test do
    system bin/"pngcheck", test_fixtures("test.png")
  end
end
