class Cdparanoia < Formula
  desc "Audio extraction tool for sampling CDs"
  homepage "https://www.xiph.org/paranoia/"
  url "https://downloads.xiph.org/releases/cdparanoia/cdparanoia-III-10.2.src.tgz", using: :homebrew_curl
  mirror "https://ftp.osuosl.org/pub/xiph/releases/cdparanoia/cdparanoia-III-10.2.src.tgz"
  sha256 "005db45ef4ee017f5c32ec124f913a0546e77014266c6a1c50df902a55fe64df"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/cdparanoia/?C=M&O=D"
    regex(/href=.*?cdparanoia-III[._-]v?(\d+(?:\.\d+)+)\.src\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "361426040e284704a73d9359498e8cc825bd339bed43f7c949dddcae1c31f179"
    sha256 cellar: :any,                 arm64_monterey: "d985bd81e9a8f5bb4f9f01a43138f1b89b385337ea2e48a22511634869496446"
    sha256 cellar: :any,                 arm64_big_sur:  "79d03f652937117697ae235b7bbb8558be9cb86edc42c330316204a288d5cb59"
    sha256 cellar: :any,                 ventura:        "262d34a4414ff6cc2194c3055ef340cebf9688a19460ade745d4b5fdb085947f"
    sha256 cellar: :any,                 monterey:       "ffe04653654cb899301fe3d0a65a207928ac26b712ef81952f9c46a06f64185d"
    sha256 cellar: :any,                 big_sur:        "2b7649f89581be2a35b246e4aab15e936573d3920f794ae5187e23b796874dbf"
    sha256 cellar: :any,                 catalina:       "9a2def6e4aa8db0e7f35392dd73e2bbaf86a52ddc5cb6ff80e1fcf6f34f6133e"
    sha256 cellar: :any,                 mojave:         "68b478e2d9e8f7121040f99551a45cab8dd8cd91d94e8690ea17103d884daeaf"
    sha256 cellar: :any,                 high_sierra:    "8b8b1eeb36773ce01ef09232e2e7270fc759aedd1814218cbd8eb9f668a4bf73"
    sha256 cellar: :any,                 sierra:         "709190d769f7b8c61d19867ae2faf902a2f84dec6f0d5506bd71c56a99e4a67a"
    sha256 cellar: :any,                 el_capitan:     "135250473fe692dc976ecbf7324676fa8cef3cdb48a091287bb183c31548fed9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "260243bbe3a8e726d4a9e8207c1905086fbe2375c29c10c91bd31ddd3a4f8f40"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  # Patches via MacPorts
  patch do
    on_macos do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/2a22152/cdparanoia/osx_interface.patch"
      sha256 "3eca8ff34d2617c460056f97457b5ac62db1983517525e5c73886a2dea9f06d9"
    end
  end

  patch do
    on_linux do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/bfad134/cdparanoia/linux_fpic.patch"
      sha256 "496f53d21dde7e23f4c9cf1cc28219efcbb5464fe2abbd5a073635279281c9c4"
    end
  end

  def install
    ENV.deparallelize

    # Libs are installed as keg-only because most software that searches for cdparanoia
    # will fail to link against it cleanly due to our patches
    # RPATH to libexec on Linux must be added so that the linker can find keg-only libraries.
    unless OS.mac?
      ENV.append "LDFLAGS", "-Wl,-rpath,#{libexec}"
      inreplace "paranoia/Makefile.in",
                "-L ../interface",
                "-Wl,-rpath,#{Formula["cdparanoia"].libexec} -L ../interface"
    end

    system "autoreconf", "-fiv"
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
