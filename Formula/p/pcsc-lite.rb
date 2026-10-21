class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.apdu.fr/"
  url "https://pcsclite.apdu.fr/files/pcsc-lite-2.5.3.tar.xz"
  sha256 "fe2bb733ecf95e52768907eb00da9f9f3daf180960283e514a05dcc090afa3bd"
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
    sha256 cellar: :any, arm64_golden_gate: "f3dcd0787951e799f44e19f443d133e54939dc39450d28d4747020b4a5c4ecba"
    sha256 cellar: :any, arm64_tahoe:       "21581ced532ed140a32fc3918d2bd9f4636314153f33ccc8504a60672703d4c9"
    sha256 cellar: :any, arm64_sequoia:     "682a173b73f5a2e698ee2fa35687f16449cd934d79d21ddca875ddc38318e8b7"
    sha256 cellar: :any, arm64_linux:       "9c5fd338e35936862b3a1ea2614c5d0280df0e30d3a3e00b0f5a9ad5a4ec528c"
    sha256 cellar: :any, x86_64_linux:      "74ab0056416c91b78ffb153cfeb4f34a2fb61b48c769de2ffa3a32d1474ebe11"
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
