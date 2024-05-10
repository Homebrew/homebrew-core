class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.apdu.fr/"
  url "https://pcsclite.apdu.fr/files/pcsc-lite-2.2.1.tar.xz"
  sha256 "625edcd6cf4b45af015eb5b6b75ea47f8914e892774c67e1079c9553c8665a57"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "ISC"]

  livecheck do
    url "https://pcsclite.apdu.fr/files/"
    regex(/href=.*?pcsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "4746e8e5d5bc6b4e84b88bcfe76c493be021d37f980dc9de4616c8e1224f4735"
    sha256 cellar: :any, arm64_ventura:  "ae992e1ae3729d118e11ba5f3fb7101b510f2eb3e50a4c933e9fd22cde79bd3b"
    sha256 cellar: :any, arm64_monterey: "0900c7618e1d9bb11cbca8a52e7072b1653560a66e08093d5d8949d7cacab0f9"
    sha256 cellar: :any, sonoma:         "64e7a271bf448a3cb6a380ddbf720c417824ed989770b530f3637db111996b42"
    sha256 cellar: :any, ventura:        "ebbb24fd91fb7faa82f1a7571e2e42af56401928ed41c9476e30ad053e694b29"
    sha256 cellar: :any, monterey:       "cb6ab4879a15b3b822fbfdea9928e8e7514ccaf81879a4ff0916f3659f624585"
    sha256               x86_64_linux:   "5cc5c4935944015f5cd1662ad6a51d752c20751c84a8abc1482bc97fc924a45c"
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
