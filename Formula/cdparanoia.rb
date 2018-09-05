class Cdparanoia < Formula
  desc "Audio extraction tool for sampling CDs"
  homepage "https://www.xiph.org/paranoia/"
  url "https://downloads.xiph.org/releases/cdparanoia/cdparanoia-III-10.2.src.tgz"
  sha256 "005db45ef4ee017f5c32ec124f913a0546e77014266c6a1c50df902a55fe64df"

  bottle do
    cellar :any
    sha256 "68b478e2d9e8f7121040f99551a45cab8dd8cd91d94e8690ea17103d884daeaf" => :mojave
    sha256 "8b8b1eeb36773ce01ef09232e2e7270fc759aedd1814218cbd8eb9f668a4bf73" => :high_sierra
    sha256 "709190d769f7b8c61d19867ae2faf902a2f84dec6f0d5506bd71c56a99e4a67a" => :sierra
    sha256 "135250473fe692dc976ecbf7324676fa8cef3cdb48a091287bb183c31548fed9" => :el_capitan
    sha256 "3cd7bbd1a4a0a7992287b255cf0d6409bdb5f4a3fed245b0fd2296e535e9f2de" => :yosemite
    sha256 "14ec797a041edffe73fef897853a833e5588278c03511f27499e55efb68c848d" => :mavericks
  end

  depends_on "autoconf" => :build

  # Patches via MacPorts
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/2a22152/cdparanoia/osx_interface.patch"
    sha256 "3eca8ff34d2617c460056f97457b5ac62db1983517525e5c73886a2dea9f06d9"
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
