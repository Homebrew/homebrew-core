class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.apdu.fr/"
  url "https://pcsclite.apdu.fr/files/pcsc-lite-2.4.0.tar.xz"
  sha256 "22307017a99e123dbecb991136783beca07966f1376d74d9ad0004ba5f81c4f1"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "ISC"]

  livecheck do
    url "https://pcsclite.apdu.fr/files/"
    regex(/href=.*?pcsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "624e3633fdfb5bde643c14849b17220fb75205b05b59366a39718a07f204b196"
    sha256 cellar: :any, arm64_sequoia: "0e94c4180a09b362bb8fcd80176b9241cbe0f4e1627d3c3d7ddc3fee2c511e55"
    sha256 cellar: :any, arm64_sonoma:  "8d4a14f8e2b1c0ef123148ac876acbbb4d71442bb0b674b4c5c665566edc614d"
    sha256 cellar: :any, sonoma:        "cf1d373145c45d0c6f7622d8d80d68a8647bdb0184ab7ff64c1e6466a29d1418"
    sha256               arm64_linux:   "9b2e981ff7c80e860eb43ab3cf95029460c4a88f586ee06b30a0ae2886286720"
    sha256               x86_64_linux:  "63dd908bb72b286a75adf102a827e95013f63931347940e82dc0ea9ea90eaa32"
  end

  keg_only :shadowed_by_macos, "macOS provides PCSC.framework"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

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
