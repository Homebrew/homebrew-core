class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.apdu.fr/"
  url "https://pcsclite.apdu.fr/files/pcsc-lite-1.9.7.tar.bz2"
  sha256 "92c1ef6e94170ac06c9c48319a455ad6de5bcc60d9d055a823b72a2f4ff3e466"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "ISC"]

  livecheck do
    url "https://pcsclite.apdu.fr/files/"
    regex(/href=.*?pcsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "dc38ae023bbf4d38ae4c0193618ccfa3b4be532e5ed048dfcb8913b69a69ecd3"
    sha256 cellar: :any,                 arm64_big_sur:  "b8cf7ce5a53d56e03f424f8d7b1a4b5668e70fae37c4286ecb6b5b914defd7c5"
    sha256 cellar: :any,                 monterey:       "ca4f864d53db2117d0cdac550db6156e8582d5c777ac05bfc5d8c61c8f08acee"
    sha256 cellar: :any,                 big_sur:        "2591776f30bca2389d86e30278f1fe5d6f47cf6327179eb6dfdcf9eba5316741"
    sha256 cellar: :any,                 catalina:       "fc57826505f41bc14bb778ad5ff3e26ce5681dbe079489da26bb54d3658e007e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6eb5bbe2ec894465c3e5aba160e067b53bd5c9f087b0fcaa35b86f79cd5411b1"
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
