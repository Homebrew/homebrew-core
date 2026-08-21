class Libirecovery < Formula
  desc "Library and utility to talk to iBoot/iBSS via USB"
  homepage "https://www.libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libirecovery/releases/download/1.3.1/libirecovery-1.3.1.tar.bz2"
  sha256 "28a3a521782063c8eb2ee5f4c0f38a517e023853edb55856052cdd7ac400381b"
  license "LGPL-2.1-only"
  head "https://github.com/libimobiledevice/libirecovery.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "14126dca02da81d6266e719840639fa3c7dba674a7fe5e22fe39c856f5f1eafd"
    sha256 cellar: :any,                 arm64_sequoia: "5b65d2e4775295b517a4324c43c0f9553871fafe19f423b890d9355f76050a69"
    sha256 cellar: :any,                 arm64_sonoma:  "d248aaefd0b49f856770bbc48c531b624b9e64ae203af153dc2f3be3cadeae49"
    sha256 cellar: :any,                 sonoma:        "139905a8f27754ed0ad2546491a171679fc2823e1060dbf2e1ff7e09a3b9de8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e51daa52330dffe61ac4fa323b48023c9d638e960d977ddd0bc834d2d5483639"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95cb02d908ffb064784fd215510258e01417621f2689df80a7e702c7b02b3d96"
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
