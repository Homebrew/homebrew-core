class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.apdu.fr/"
  url "https://pcsclite.apdu.fr/files/pcsc-lite-2.4.1.tar.xz"
  sha256 "afd3ba68c8000d2be048dc292df99a9812df9ad2efaf0a366eea22ac1faa19a7"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "ISC"]

  livecheck do
    url "https://pcsclite.apdu.fr/files/"
    regex(/href=.*?pcsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bbcb4cec53c676bc0c0d909b48a4880d0245e248301b1c02bcf2ba2db08ab29c"
    sha256 cellar: :any, arm64_sequoia: "0d2a59a7d1d8b287f77d8f4fa22f465caef5b96a68f549a89add5a7d4fc21788"
    sha256 cellar: :any, arm64_sonoma:  "349f8e1bbc4fc03f07eac0abe9a9217bab513dfc79c9a8dc238cc7d5ca619ecf"
    sha256 cellar: :any, sonoma:        "0f44502f904a7084905a92de0ec7cf8433ee98b1d8190928096659caae01dbba"
    sha256               arm64_linux:   "3c60cdfcf25e57250a4259695c38127608738afc3fd9c7979a4b0387fde8402f"
    sha256               x86_64_linux:  "8646d8eae3480db54d39cd2fc59466b5f3f72c58691cf36f4b8afced83e41c1a"
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
