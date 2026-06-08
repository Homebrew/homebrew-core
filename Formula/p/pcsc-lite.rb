class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.apdu.fr/"
  url "https://pcsclite.apdu.fr/files/pcsc-lite-2.5.0.tar.xz"
  sha256 "59b3c4b5be4ab228698edeb5b3ef46ad54ea217e7dd0891372770bb92b55db92"
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
    sha256 cellar: :any,                 arm64_tahoe:   "b0b4e97cf70ff8671c91f7195e6d45c5844f732a23d3be42449ac6c0863d52fa"
    sha256 cellar: :any,                 arm64_sequoia: "9b8be9abe41e74bab7c8b85c29ab3ef44270f3df8ddd6b633f699a60ae408bab"
    sha256 cellar: :any,                 arm64_sonoma:  "4f4fc791656697bcb6996498915d53705c6065e099d4de02be694f9893115c67"
    sha256 cellar: :any,                 sonoma:        "f9fa20af6a34c96e0e7de479c8a54f69edaa725bca370cd2602841374d1a5122"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1b00f64115f3a451c380c0da338044ac025fd92394f72c517afa662af6ee2b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2ddc2d41f4d0b27ce14e2f0337269a244110cc3e44a2a631228e0343a214daf"
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
