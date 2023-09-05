class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.apdu.fr/"
  url "https://pcsclite.apdu.fr/files/pcsc-lite-2.0.0.tar.bz2"
  sha256 "d6c3e2b64510e5ed6fcd3323febf2cc2a8e5fda5a6588c7671f2d77f9f189356"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "ISC"]

  livecheck do
    url "https://pcsclite.apdu.fr/files/"
    regex(/href=.*?pcsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f3bb47aadcadded2aa7dc974ea4776ab2d2a83a84d1dc49b9da2b193a1dff18a"
    sha256 cellar: :any,                 arm64_monterey: "6562c3d1259a6b374948568a8c8912dbfab57d6908b3c8f722bbe267fb12bdec"
    sha256 cellar: :any,                 arm64_big_sur:  "8842afebce7f1f49b4c4bcfd27f265796170c2a9c05d085653a6585adb83d36e"
    sha256 cellar: :any,                 ventura:        "2bbf9296a78fb012b5846f9d2bac850e5dd8fe74fbe08fcf5a4cd8ee921d9bb2"
    sha256 cellar: :any,                 monterey:       "9e8b14094fcf0ac9724251309ccb84fd995826b4460716277d466201e17c784f"
    sha256 cellar: :any,                 big_sur:        "5e3b65fd730f8454409eeee874916ba1d70e2367da4845794ca98d3afbae9c89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "508f16bcfdfa4dbfc0bc8d918f262e73e872d381cf68fc993c1e6bb8cd9e1419"
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
