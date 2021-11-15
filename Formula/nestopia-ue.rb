class NestopiaUe < Formula
  desc "NES emulator"
  homepage "http://0ldsk00l.ca/nestopia/"
  url "https://github.com/0ldsk00l/nestopia/archive/1.51.1.tar.gz"
  sha256 "6c2198ed5f885b160bf7e22a777a5e139a7625444ec47625cd07a36627e94b3f"
  license "GPL-2.0-or-later"
  head "https://github.com/0ldsk00l/nestopia.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "74968127ee6cfe14c8f08fd7e0f53cd3149649047b703d51fe765f30c47eb7ca"
    sha256 arm64_big_sur:  "48cc9146b538dde455e89b91882abc5cb6e0a3bb5272d546c747df16a7399379"
    sha256 monterey:       "a7a0e0e9ba892d561e14e0ac7cd99f4d4aaed37669d778c646d06ea582c655c4"
    sha256 big_sur:        "c3b7a00feb7ccce40ed9edf2dc3a00aaea2c6422912a13917c481cd5389f4838"
    sha256 catalina:       "8a08b57d2e7287b0792d3c0ae3688e563e6efd15a7069525ab62836ba8c6f924"
    sha256 mojave:         "5fb8a05db0ae55c4d2bf0be06a88a825a0c502cdf289119c088eabe660e7eab2"
    sha256 x86_64_linux:   "e4d3611733b865fb44f3edacf8963bb87a7ea31bc1a1f47b9d08fcd3678a7b43"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "fltk"
  depends_on "libarchive"
  depends_on "sdl2"

  uses_from_macos "zlib"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--datarootdir=#{pkgshare}"
    system "make", "install"
  end

  test do
    assert_match(/Nestopia UE #{version}$/, shell_output("#{bin}/nestopia --version"))
  end
end
