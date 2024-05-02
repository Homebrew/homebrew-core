class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.apdu.fr/"
  url "https://pcsclite.apdu.fr/files/pcsc-lite-2.1.0.tar.bz2"
  sha256 "85cab61cc744c81e2bc432656863293b8428d0136f079e3b12a84b335b5b35aa"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "ISC"]

  livecheck do
    url "https://pcsclite.apdu.fr/files/"
    regex(/href=.*?pcsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4eee84ad5010a61e84b204d47b7c435800d3b68cbb234b2da73f2fe18b24797e"
    sha256 cellar: :any,                 arm64_ventura:  "4233c25121f4c58bcf8275cc63736b40ffc169dd249019ef96f1e71dcccec965"
    sha256 cellar: :any,                 arm64_monterey: "e104244b6be4cea6173f2bca40a3dfc29ea02dd470ab07cd27126ee61e445606"
    sha256 cellar: :any,                 sonoma:         "496b1a2e19f5a41dcc88d1a1f93e046c09b0f8a2bf989b4c9d97b74d017a811a"
    sha256 cellar: :any,                 ventura:        "892dea01362e57991ec396f34e3a55a0a10064df9c053ed972d041e20bad552f"
    sha256 cellar: :any,                 monterey:       "48b72b88b9b7e4b920d125bcfe4ddbeb81764bd079c6bfc3f8e82d13da516bf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7af2df4cd20868d1fcad5abad233be678fb6b3a778798a673b6b299f501fae46"
  end

  keg_only :shadowed_by_macos, "macOS provides PCSC.framework"

  uses_from_macos "flex" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libusb"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --disable-libsystemd
      --disable-polkit
    ]

    args << "--disable-udev" if OS.linux?

    system "./configure", *args
    system "make", "install"
  end

  test do
    system sbin/"pcscd", "--version"
  end
end
