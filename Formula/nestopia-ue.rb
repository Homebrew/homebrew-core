class NestopiaUe < Formula
  desc "NES emulator"
  homepage "http://0ldsk00l.ca/nestopia/"
  license "GPL-2.0-or-later"
  head "https://github.com/0ldsk00l/nestopia.git"

  # Remove stable block in next release with merged patch
  stable do
    url "https://github.com/0ldsk00l/nestopia/archive/1.51.0.tar.gz"
    sha256 "9dd3253629a05f68fb730e5bc59148cd5498cea359eff2cbf4202d1e1329bce9"

    # Fix for build issue: https://github.com/0ldsk00l/nestopia/issues/353
    # Remove in the next release
    patch do
      url "https://github.com/0ldsk00l/nestopia/commit/d57e02e19ba88d609a092da5b420432a7251b71d.patch?full_index=1"
      sha256 "5eba25a40d1b1cefd864e2f3fad160c438f3cb7a1257bea20bbc93c0235c1123"
    end
  end

  bottle do
    sha256 arm64_big_sur: "21dd1ec76826e208b26d981ebfafbef95d8c2f4a00330cd7556bc366e5bc7745"
    sha256 big_sur:       "d6a31de30e416aaa7cb365b22c35555947fa4967d3f0d7b334694e63e70c08a8"
    sha256 catalina:      "19acd9260a874dec614062d0362a5936a0d9322e9fe66f0f8426d0dec67a6dd6"
    sha256 mojave:        "e41a57949e9ebeffd1fa72de619da0dc2bbc813adf1b83922a0151362a9b9f04"
    sha256 high_sierra:   "dc7632deb424cbfd112350aa1ddad0d1b0715cce9ebfda0bbbd8e77640cea044"
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
