class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.apdu.fr/"
  url "https://pcsclite.apdu.fr/files/pcsc-lite-2.3.3.tar.xz"
  sha256 "cdff7d7153a0b37aa74e26dfec89ec7dc5c5286aa21b91b903e38739d227e8e7"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "ISC"]

  livecheck do
    url "https://pcsclite.apdu.fr/files/"
    regex(/href=.*?pcsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "f95249f28b4c8f7c3cc0a5e271bacfa26f6e1a496604daad4b08085b6c472bdc"
    sha256 cellar: :any, arm64_sonoma:  "6a8a48b4a42c96852e25c8cef498c0c69fd81d88870905f843950c046ba27782"
    sha256 cellar: :any, arm64_ventura: "cd73572b68d633209717cdf8b804b5bbd099a74f36d330e8e96e09286e45430f"
    sha256 cellar: :any, sonoma:        "6b85920c94e2410027d9e6c32a6c0260ba41bd0edf673e681177c87435650fb7"
    sha256 cellar: :any, ventura:       "4e5b67b3d0b3cbd84386e8d1c8032c8fb92406e41f9f6a26411028bfa5a831f1"
    sha256               arm64_linux:   "7b3bce7cfc254db6c5aced0f48a73daae93a0082f01c1db1aadb828f681c8733"
    sha256               x86_64_linux:  "3264145e978cc211a9c213676ddbe44f8b890296d5aded28c9f8e247bd321c6b"
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
