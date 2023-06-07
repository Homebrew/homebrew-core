class Ncview < Formula
  desc "Visual browser for netCDF format files"
  homepage "https://cirrus.ucsd.edu/ncview/"
  url "ftp://cirrus.ucsd.edu/pub/ncview/ncview-2.1.8.tar.gz"
  sha256 "e8badc507b9b774801288d1c2d59eb79ab31b004df4858d0674ed0d87dfc91be"
  license "GPL-3.0-only"
  revision 6

  # The stable archive in the formula is fetched over FTP and the website for
  # the software hasn't been updated to list the latest release (it has been
  # years now). We're checking Debian for now because it's potentially better
  # than having no check at all.
  livecheck do
    url "https://deb.debian.org/debian/pool/main/n/ncview/"
    regex(/href=.*?ncview[._-]v?(\d+(?:\.\d+)+)(?:\+ds)?\.orig\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "00202073aeffac85fd800347d7c3854cc4d4de99bd6e4283541bb81baabc62c2"
    sha256 cellar: :any,                 arm64_monterey: "f80fbf9c909cc45a91d44cdb8244a64fa57e53e95765f9d3e24cfb22b4fc9ea1"
    sha256                               arm64_big_sur:  "891d85685f499d86b5666a688f1fed2e406a05082a0bd3916b5da325230d6c4b"
    sha256 cellar: :any,                 ventura:        "9251eb13ae369b765732d7f71dd1beb98bfdecec4f76d52dac569581408d5323"
    sha256 cellar: :any,                 monterey:       "f8248fcbfd8e33f1bbda3924d7dfcbd1c0a1968089f492ca0f0a487ef21beaa7"
    sha256                               big_sur:        "6129b591b2b0238a0e61ec86ebc5d875a494e677963656b679300e67f874c13c"
    sha256                               catalina:       "93d6850d0542b7ea67b442f1ea80d63b80a04c872f0c4d25d0713f3fba5b92a2"
    sha256                               mojave:         "0b8b3c63895071a605b80ab1c1576356d1bfe634857e78f2cf3cb22742de09c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c78f5b727f31fc213d111d63aa8a7f27193746a4dd3657c8a21ed33cb5a02423"
  end

  depends_on "libice"
  depends_on "libpng"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxaw"
  depends_on "libxt"
  depends_on "netcdf"
  depends_on "udunits"

  on_linux do
    depends_on "libxext"
  end

  def install
    # Bypass compiler check (which fails due to netcdf's nc-config being
    # confused by our clang shim)
    inreplace "configure",
      "if test x$CC_TEST_SAME != x$NETCDF_CC_TEST_SAME; then",
      "if false; then"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    man1.install "data/ncview.1"
  end

  test do
    assert_match "Ncview #{version}",
                 shell_output("DISPLAY= #{bin}/ncview -c 2>&1", 1)
  end
end
