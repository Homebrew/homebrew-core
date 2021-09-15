class Cdparanoia < Formula
  desc "Audio extraction tool for sampling CDs"
  homepage "https://www.xiph.org/paranoia/"
  url "https://downloads.xiph.org/releases/cdparanoia/cdparanoia-III-10.2.src.tgz"
  mirror "https://ftp.osuosl.org/pub/xiph/releases/cdparanoia/cdparanoia-III-10.2.src.tgz"
  sha256 "005db45ef4ee017f5c32ec124f913a0546e77014266c6a1c50df902a55fe64df"

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/cdparanoia/?C=M&O=D"
    regex(/href=.*?cdparanoia-III[._-]v?(\d+(?:\.\d+)+)\.src\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "79d03f652937117697ae235b7bbb8558be9cb86edc42c330316204a288d5cb59"
    sha256 cellar: :any, big_sur:       "2b7649f89581be2a35b246e4aab15e936573d3920f794ae5187e23b796874dbf"
    sha256 cellar: :any, catalina:      "9a2def6e4aa8db0e7f35392dd73e2bbaf86a52ddc5cb6ff80e1fcf6f34f6133e"
    sha256 cellar: :any, mojave:        "68b478e2d9e8f7121040f99551a45cab8dd8cd91d94e8690ea17103d884daeaf"
    sha256 cellar: :any, high_sierra:   "8b8b1eeb36773ce01ef09232e2e7270fc759aedd1814218cbd8eb9f668a4bf73"
    sha256 cellar: :any, sierra:        "709190d769f7b8c61d19867ae2faf902a2f84dec6f0d5506bd71c56a99e4a67a"
    sha256 cellar: :any, el_capitan:    "135250473fe692dc976ecbf7324676fa8cef3cdb48a091287bb183c31548fed9"
    sha256 cellar: :any, yosemite:      "3cd7bbd1a4a0a7992287b255cf0d6409bdb5f4a3fed245b0fd2296e535e9f2de"
  end

  depends_on "autoconf" => :build

  # Patches via MacPorts
  on_macos do
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/2a22152/cdparanoia/osx_interface.patch"
      sha256 "3eca8ff34d2617c460056f97457b5ac62db1983517525e5c73886a2dea9f06d9"
    end
  end

  on_linux do
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/bfad134/cdparanoia/linux_fpic.patch"
      sha256 "496f53d21dde7e23f4c9cf1cc28219efcbb5464fe2abbd5a073635279281c9c4"
    end
  end

  def install
    system "autoconf"
    # Libs are installed as keg-only because most software that searches for cdparanoia
    # will fail to link against it cleanly due to our patches
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--libdir=#{libexec}"
    system "make", "all"
    system "make", "install"
  end

  test do
    system "#{bin}/cdparanoia", "--version"
  end
end
