class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.apdu.fr/"
  url "https://pcsclite.apdu.fr/files/pcsc-lite-2.5.1.tar.xz"
  sha256 "bfcfe38a20afc49849c6bf55325e38f449fc4b26d3923fdc32b969ae41a8741b"
  license all_of: [
    "BSD-3-Clause",
    "BSD-2-Clause",     # src/auth.*
    "GPL-3.0-or-later", # src/spy/ (libpcscspy, pcsc-spy)
    "ISC",              # src/simclist.*
  ]

  livecheck do
    url "https://pcsclite.apdu.fr/files/"
    regex(/href=.*?pcsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f49d472947f78d06c3e3290396f1f92f2ce91280fb0e326a88dee53d0b424128"
    sha256 cellar: :any, arm64_sequoia: "4d5ca00a9976d4c91ddea7040632fdddbd97b2ed0fd3ab890f123e3d281c523c"
    sha256 cellar: :any, arm64_sonoma:  "dded6282ec1ef89650c2c0f24003da1980eceeacab7251edf11c57160386e370"
    sha256 cellar: :any, sonoma:        "3ec7b322b383caf6cd359a47d48ac3a226e42c0e4a5e78efb88ab17f81189349"
    sha256 cellar: :any, arm64_linux:   "673dafcfadb1364bc7d8e7db7ece21a4a9d1830739117c64df473deada17b673"
    sha256 cellar: :any, x86_64_linux:  "2783208846a4ebf626fe77c1cec77d950d84bfe5bc1e9f6771a12a77277a6723"
  end

  keg_only :shadowed_by_macos, "macOS provides PCSC.framework"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  uses_from_macos "flex" => :build

  def install
    args = %W[
      -Dlibsystemd=false
      -Dlibudev=false
      -Dpolkit=false
      -Dipcdir=#{var}/run
      -Dsysconfdir=#{etc}
      -Dsbindir=#{sbin}
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system sbin/"pcscd", "--version"
  end
end
