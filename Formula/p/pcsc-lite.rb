class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.apdu.fr/"
  url "https://pcsclite.apdu.fr/files/pcsc-lite-2.5.2.tar.xz"
  sha256 "60a08942d8c00a1d86a3bf4c64eddbf7a5569c7c54f6904e3f07801bb5316acd"
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
    sha256 cellar: :any, arm64_golden_gate: "b5e6b6ad1c3d21ec523a5785400b366589134a8d716c3e1a63c57402004966d5"
    sha256 cellar: :any, arm64_tahoe:       "04e60294e03c6d0ebe00e4e0b4af236d5ffd8bfc79abb177305a058845577241"
    sha256 cellar: :any, arm64_sequoia:     "97e239e3482cb3a1ff387c7789e3b1454750e4a4142d8a519f97a9b93ecdb381"
    sha256 cellar: :any, arm64_linux:       "64e5c18f098bc9e828b1f61e810591333eaa772762ebaef4aa1df8e5db5cae01"
    sha256 cellar: :any, x86_64_linux:      "0c1172a8586efd07e22e23a4335e792f220b0e3a79f1dc09fac116dd6d97b3ce"
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
