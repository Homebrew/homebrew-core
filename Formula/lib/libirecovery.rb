class Libirecovery < Formula
  desc "Library and utility to talk to iBoot/iBSS via USB"
  homepage "https://www.libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libirecovery/releases/download/1.3.0/libirecovery-1.3.0.tar.bz2"
  sha256 "f9e5485e5a7ee039dd32820bf1c88d65dc0e73322a95d5e9878b06bee02f3dc8"
  license "LGPL-2.1-only"
  head "https://github.com/libimobiledevice/libirecovery.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "88698c7823a14bec2da158f1cfc360608a9d4a9ebef29cea6956eb93be004754"
    sha256 cellar: :any,                 arm64_sequoia: "cd0733daaf78059503eb27ef698f97a5734f2062cffe8201aeaba6c6b20d598f"
    sha256 cellar: :any,                 arm64_sonoma:  "e23201d201b371225729788f95281fe5367dfe9a367be2b6541bc0beb16f6468"
    sha256 cellar: :any,                 sonoma:        "d710ddb939620c8b62f48163fde9082db53388e92d9791adb9d4d7dfbf4b07b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "606482a44dd42515748abd2f0938b560aa7572f7c8c89883ab7d34c9989cf7a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45640335f78a19c6012a5a2d2d0ca575a2ce2f0303b1d2be4a28df03b51afece"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libimobiledevice-glue"

  on_macos do
    depends_on "libplist"
  end

  on_linux do
    depends_on "libusb"
    depends_on "readline"
  end

  def install
    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "ERROR: Unable to connect to device", shell_output("#{bin}/irecovery -f nothing 2>&1", 255)
  end
end
