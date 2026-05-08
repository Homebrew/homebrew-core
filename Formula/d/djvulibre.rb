class Djvulibre < Formula
  desc "DjVu viewer"
  homepage "https://djvu.sourceforge.net/"
  url "https://downloads.sourceforge.net/djvu/djvulibre-3.5.30.tar.gz"
  sha256 "ee5e457d4cfebe566f94b99e5e3d3cc7f5c79ddb741c2ac2ba2e456f00329644"
  license "GPL-2.0-or-later"
  compatibility_version 1

  livecheck do
    url :stable
    regex(%r{url=.*?/djvulibre[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "5039f6f0f6a4487565d093e250ea699acb30308f85c828e098b53a454021d446"
    sha256 arm64_sequoia: "d828e09fa7ba7c8b4e1c5df16ccd47129ab8b60e1e63953db28026cb73632c6c"
    sha256 arm64_sonoma:  "0bd317798e13d3319d2836c08c2218b50285708f5c5d87fda0919b63fd9c4798"
    sha256 sonoma:        "e0a0acf06178dd606b49dccfdf52c300700ac3319e96bb93ca7c8b1e7678484b"
    sha256 arm64_linux:   "1327990b93502b056f917b818a957b7a7b34e981179d8c2d09ff37b81c009986"
    sha256 x86_64_linux:  "ff0c780ed64168eec0fb1bd8111ed0ec7d06c1408336f8b0c066ad799591a3ff"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "jpeg-turbo"
  depends_on "libtiff"

  def install
    system "./autogen.sh"
    # Don't build X11 GUI apps, Spotlight Importer or Quick Look plugins
    system "./configure", "--prefix=#{prefix}", "--disable-desktopfiles"
    system "make"
    system "make", "install"
    (share/"doc/djvu").install Dir["doc/*"]
  end

  test do
    output = shell_output("#{bin}/djvused -e n #{share}/doc/djvu/lizard2002.djvu")
    assert_equal "2", output.strip
  end
end
