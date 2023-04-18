class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.apdu.fr/"
  url "https://pcsclite.apdu.fr/files/pcsc-lite-1.9.9.tar.bz2"
  sha256 "cbcc3b34c61f53291cecc0d831423c94d437b188eb2b97b7febc08de1c914e8a"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "ISC"]

  livecheck do
    url "https://pcsclite.apdu.fr/files/"
    regex(/href=.*?pcsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b870e407020eeec5d190dfb064723e3af63157c51d1a45bc4c11ca79a6c16476"
    sha256 cellar: :any,                 arm64_monterey: "3e398a322c62a2b600982100ec3c35d13d3f4c1cf5714fa91c8c5b69652d0d5a"
    sha256 cellar: :any,                 arm64_big_sur:  "7df5425e9242a4322f303555d9b8aff55601da15be1e1a76093d3bac8ba822c0"
    sha256 cellar: :any,                 ventura:        "c35348b30d24a1338d02d7fd4ec81b88fbb1392dc23bf1c1574fc19b19429e74"
    sha256 cellar: :any,                 monterey:       "9928ccd674122c0479759e48ddf57e96dbef2b202c72bce529b8fbc4e6a54aff"
    sha256 cellar: :any,                 big_sur:        "1bd869f97882367992178408a6de15a483139a2469b39bf6f8689790571e8b48"
    sha256 cellar: :any,                 catalina:       "b0cd2a105e82fe5aedf2fbeed2421d93bc575374620e1d0bc5e0c3dc3c6d8738"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab7816f9ae7c2e00f4398c3551247c5be9f5726b05ff706978d43827450aea76"
  end

  keg_only :shadowed_by_macos, "macOS provides PCSC.framework"

  uses_from_macos "flex" => :build

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
