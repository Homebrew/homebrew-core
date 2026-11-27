class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.apdu.fr/"
  url "https://pcsclite.apdu.fr/files/pcsc-lite-2.5.4.tar.xz"
  sha256 "23b1c644ab4f13269d3a9ff26734f473f622deff6ed60492171a9a25f603f078"
  license all_of: [
    "BSD-3-Clause",
    "BSD-2-Clause",     # src/auth.*
    "GPL-3.0-or-later", # src/spy/ (libpcscspy, pcsc-spy)
    "ISC",              # src/simclist.*
  ]
  compatibility_version 1

  livecheck do
    url "https://pcsclite.apdu.fr/files/"
    regex(/href=.*?pcsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "fe9a5b59a1af63cb34f2d6e624069e8f4f9e1e027f7027321ca0243a5347e23e"
    sha256 cellar: :any, arm64_golden_gate: "503f966865ba587bc44a11643ca38e93e50a24c62e085ef2e9704b66a45811e2"
    sha256 cellar: :any, arm64_tahoe:       "396b6c078477107839c5e8bab551740b858ac5ecf5f03891c3700c50e63ca4bb"
    sha256 cellar: :any, arm64_sequoia:     "0e71d7de444b79bf63c7ab741d43cf11092c9b7527c49197d672e8d0932308fb"
    sha256 cellar: :any, arm64_linux:       "edf749b85d0c7c7bd71c0b9787652b6c9b4f2b8daee7f8945275c4b41cfaa6ba"
    sha256 cellar: :any, x86_64_linux:      "5892b50d04ee592680cb4cd181e4863e1bfbc7528aec3fd978a6f0dbb2907fe3"
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
