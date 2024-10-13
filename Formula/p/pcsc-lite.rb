class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.apdu.fr/"
  url "https://pcsclite.apdu.fr/files/pcsc-lite-2.3.0.tar.xz"
  sha256 "1acca22d2891d43ffe6d782740d32e78150d4fcc99e8a3cc763abaf546060d3d"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "ISC"]

  livecheck do
    url "https://pcsclite.apdu.fr/files/"
    regex(/href=.*?pcsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "1111b3cf358a59319cd87c4d2954d2b1e753302fc76146399c11504e4573a165"
    sha256 cellar: :any, arm64_sonoma:   "d30c8cb99810d23d47a070f9480e2971ea2462022a918434a68281bb25a7fdff"
    sha256 cellar: :any, arm64_ventura:  "451a9493866942139440d2d67fdba6564a8e64e95dedf20e6516b227ce1ed6f7"
    sha256 cellar: :any, arm64_monterey: "b9541aab03a842aae04aad901ffc9abaf2eef5372fc81843aa74df3f31aaeac8"
    sha256 cellar: :any, sonoma:         "0fa3c548693e80a567bef8d84eba6d4a65a77382f63d9abc850b97555720a893"
    sha256 cellar: :any, ventura:        "b0989b778d952162a38f028e7f229feba4b39ce362a623b1580a09e4f1d5326d"
    sha256 cellar: :any, monterey:       "8f638d483e96d926e7dc7dc5a81b383d28ce858dfb10239000e72a6744eb0d0e"
    sha256               x86_64_linux:   "78f2c4ea16d1369f3d16e77dc3852197498ebbff8daa227d178bc7e7ee097def"
  end

  keg_only :shadowed_by_macos, "macOS provides PCSC.framework"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "flex" => :build

  on_linux do
    depends_on "libusb"
    depends_on "systemd" # for libudev
  end

  def install
    args = %W[
      -Dlibsystemd=false
      -Dlibudev=false
      -Dpolkit=false
      -Dipcdir=#{var}/run
      -Dsysconfdir=#{etc}
      -Dsbindir=#{sbin}
    ]

    args << "-Dlibudev=false" if OS.linux?

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system sbin/"pcscd", "--version"
  end
end
