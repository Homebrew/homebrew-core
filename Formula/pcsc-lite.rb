class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.apdu.fr/"
  url "https://pcsclite.apdu.fr/files/pcsc-lite-1.9.4.tar.bz2"
  sha256 "8a8caac227e0a266015298dda663e81576a0d11d698685101e6aa6c9fdb51c4b"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "ISC"]

  livecheck do
    url "https://pcsclite.apdu.fr/files/"
    regex(/href=.*?pcsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4ef8398590fa718d03ca29f491752d0539fa4d2db5fb649efff6ee96a0cb1227"
    sha256 cellar: :any,                 arm64_big_sur:  "2a2c65f8456b5f8a409a5ce90601539b23553ded657c0049c36311d52584dd87"
    sha256 cellar: :any,                 monterey:       "5402d013314d46d63a5f0932ca9751fcdefeb3171389a191fccbd79d6711d208"
    sha256 cellar: :any,                 big_sur:        "f5d733e1cccba6a07f87b29ec9a18886d210376ea13d0a42eeacdadb706c97a3"
    sha256 cellar: :any,                 catalina:       "e97ed967e538b00673e7b0e46592adafd3dbc0f69bb67aea921fe24e51c376ff"
    sha256 cellar: :any,                 mojave:         "4afd86caaf938458d6697b216f0c6760e4d1e7b8228995943e316eb6bf315476"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbbcbdc0bab21c08e55d7f5d8e897cc5f17dd3e387a38c9e11480996c189f050"
  end

  keg_only :shadowed_by_macos, "macOS provides PCSC.framework"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libusb"
  end

  def install
    args = %W[--disable-dependency-tracking
              --disable-silent-rules
              --prefix=#{prefix}
              --sysconfdir=#{etc}
              --disable-libsystemd]

    args << "--disable-udev" if OS.linux?

    system "./configure", *args
    system "make", "install"
  end

  test do
    system sbin/"pcscd", "--version"
  end
end
