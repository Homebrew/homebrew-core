class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.apdu.fr/"
  url "https://pcsclite.apdu.fr/files/pcsc-lite-2.3.1.tar.xz"
  sha256 "a641d44d57affe1edd8365dd75307afc307e7eefb4e7ad839f6f146baa41ed56"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "ISC"]

  livecheck do
    url "https://pcsclite.apdu.fr/files/"
    regex(/href=.*?pcsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "3ca118a06f993b4e816cb413ce785e9de04ac644935ef249537ad072f0870a36"
    sha256 cellar: :any, arm64_sonoma:  "b49c4bd9527a8160c09e3c9484c6b0728517338c69ce4177b17062c2bb7b9491"
    sha256 cellar: :any, arm64_ventura: "6705e2237d956fc2efb95afde3bfac55ede429a1d3f36566a5e976cbd588de90"
    sha256 cellar: :any, sonoma:        "2420823643965f84f9b96f98c2892fa4eb4277d573d0a2363ee580fef9182929"
    sha256 cellar: :any, ventura:       "7773c59109c4cecd12b1bd9cb447254d2e7d8d483117169a6bde6fd8eca8bfbd"
    sha256               x86_64_linux:  "06be6fce142f34e1b661bde9814ce8cbf718300754fa586c5e5ca7a543dc0fa3"
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
