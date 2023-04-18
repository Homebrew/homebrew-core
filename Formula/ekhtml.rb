class Ekhtml < Formula
  desc "Forgiving SAX-style HTML parser"
  homepage "https://ekhtml.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ekhtml/ekhtml/0.3.2/ekhtml-0.3.2.tar.gz"
  sha256 "1ed1f0166cd56552253cd67abcfa51728ff6b88f39bab742dbf894b2974dc8d6"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "58b661aa5f68e984f1fda1ccf0dd9dd9a9ab0f445c9069d96893d558e441dac8"
    sha256 cellar: :any,                 arm64_monterey: "b438d00a18912a1940d38e03386c8589e62083534e0f72608e7a5824418f8109"
    sha256 cellar: :any,                 arm64_big_sur:  "b8f8bd224e339d7aa4e95a94c23fcb93cae06533927256465c7c7719fef46c76"
    sha256 cellar: :any,                 ventura:        "3d1bdcc582ab80b004131b68622139a924f0dd4c1ee7a8f8fa3284d5736e4222"
    sha256 cellar: :any,                 monterey:       "252e39e34ceaa9454a21a16db39556a06ae13701f31671ec8354c86be76107c0"
    sha256 cellar: :any,                 big_sur:        "238ffdbf0c5a207667215d75c4a05f9b32af2ad6d9f53f256977c56623088d11"
    sha256 cellar: :any,                 catalina:       "6599b50de97ee6aec9788ac0479c2ad25f335213b3bc9bbab0e5a8ae5c142482"
    sha256 cellar: :any,                 mojave:         "99d523757e0870bdc36093895d0ac451586895ec8bed6d4df7b85da86ed13ffc"
    sha256 cellar: :any,                 high_sierra:    "d081597008ebd37b0bc69adeb365bedf296cf9a251cb81fa07671b12143a6aa8"
    sha256 cellar: :any,                 sierra:         "a4e245b9e7b3643dea35dc0b6dece64f92b76d27ec59ba28c30ea7a666254396"
    sha256 cellar: :any,                 el_capitan:     "d606a2fe3d466a5e76f22a0736f0b485be613bad4a09575d496d9396d3a71903"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8841e4eeb677f92be17fbaa26ee2d5d1e2d6ce958eff178fdb4a9fcf33ea1363"
  end

  on_macos do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    ENV.deparallelize
    # Run autoreconf on macOS to rebuild configure script so that it doesn't try
    # to build with a flat namespace.
    system "autoreconf", "--force", "--verbose", "--install" if OS.mac?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
