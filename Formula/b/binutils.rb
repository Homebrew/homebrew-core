class Binutils < Formula
  desc "GNU binary tools for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.45.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.45.tar.bz2"
  sha256 "1393f90db70c2ebd785fb434d6127f8888c559d5eeb9c006c354b203bab3473e"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later", "LGPL-2.0-or-later", "LGPL-3.0-only"]

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "fd20ebf003bed2def99e4d1394999ed18bb18cffb2ebc3780d28d20001ec70b1"
    sha256 arm64_sequoia: "3fb936ff0d64e4bc3530ab07f83417f5dea8c098549ec506f19f1c6ae4962cb6"
    sha256 arm64_sonoma:  "1a6356d10575b843eafe84253ba51c147334239b37e02d99288d998466912471"
    sha256 arm64_ventura: "4a1b661cba6a910e35d0691d2d1dda1ed6337e212fb6237a6189dfa99bb45888"
    sha256 sonoma:        "fb94a53dfab0618b68dcf429dfcd54d5854f74bff87225dc2f6465d9bb278f07"
    sha256 ventura:       "96dcff59ccbb203e0fa8ccb7a36bc9eaba8fe6a63010bbb77f1238df951bce78"
    sha256 arm64_linux:   "9d452137d4cfe39d4edbf7e9ae47389039345a3ac6ec85e9b3bcdca6911f3b75"
    sha256 x86_64_linux:  "a6a1fca273e6ac2ed2309c0f0c4180cf10fae283bc303c58da8ce3771598c1b3"
  end

  keg_only "it shadows the host toolchain"

  depends_on "pkgconf" => :build
  depends_on "zstd"

  uses_from_macos "bison" => :build
  uses_from_macos "zlib"

  skip_clean "etc/ld.so.conf"

  link_overwrite "bin/dwp"

  def install
    # Workaround https://sourceware.org/bugzilla/show_bug.cgi?id=28909
    touch "gas/doc/.dirstamp", mtime: Time.utc(2022, 1, 1)
    make_args = OS.mac? ? [] : ["MAKEINFO=true"] # for gprofng

    args = [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--enable-deterministic-archives",
      "--prefix=#{prefix}",
      "--infodir=#{info}",
      "--mandir=#{man}",
      "--disable-werror",
      "--enable-interwork",
      "--enable-multilib",
      "--enable-64-bit-bfd",
      "--enable-plugins",
      "--enable-targets=all",
      "--with-system-zlib",
      "--with-zstd",
      "--disable-nls",
    ]
    system "./configure", *args
    system "make", *make_args
    system "make", "install", *make_args

    if OS.mac?
      Dir["#{bin}/*"].each do |f|
        bin.install_symlink f => "g" + File.basename(f)
      end
    else
      # Reduce the size of the bottle.
      bin_files = bin.children.select(&:elf?)
      system "strip", *bin_files, *lib.glob("*.a")
    end

    # Allow ld to find brew glibc. A broken symlink falls back to /etc/ld.so.conf
    (prefix/"etc").install_symlink etc/"ld.so.conf" if OS.linux?
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/strings #{bin}/strings")
    assert_predicate prefix/"etc/ld.so.conf", :symlink? if OS.linux?
  end
end
