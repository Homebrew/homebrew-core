class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.apdu.fr/"
  url "https://pcsclite.apdu.fr/files/pcsc-lite-2.0.3.tar.bz2"
  sha256 "f42ee9efa489e9ff5d328baefa26f9c515be65021856e78d99ad1f0ead9ec85d"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "ISC"]

  livecheck do
    url "https://pcsclite.apdu.fr/files/"
    regex(/href=.*?pcsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b1ae0239f4908676ed19b992bde79fffe2927574f5e1810d0e46c70e531a8933"
    sha256 cellar: :any,                 arm64_ventura:  "5d1ce03b6fffc94b02219ab98db9e7a85827c7822fb272f4ca4d096ce1d98128"
    sha256 cellar: :any,                 arm64_monterey: "d30fb5e5f1995d37cc14adaf400465c7a7fc3830f6aa4b2924435c1f2cc18d58"
    sha256 cellar: :any,                 sonoma:         "93e1e47038adde366e7d61327108b31edce28cd9af23960b3ea867d64c8cb683"
    sha256 cellar: :any,                 ventura:        "2a126c16b0a2ea95eb30ae226afb3bb56061fa3f644644be0086780d42ae5fb3"
    sha256 cellar: :any,                 monterey:       "f4f13043335be66731c21f58a947038050fb0b362aa3a637c74549a86547a458"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5545739260e973f79bccfa3590e64e7cf56642d2dd2d877a5485c6e36064d00"
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
