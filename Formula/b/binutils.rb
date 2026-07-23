class Binutils < Formula
  desc "GNU binary tools for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.46.1.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.46.1.tar.bz2"
  sha256 "324ed40ada2633a28eaa5d104ca5db165fd3cc3162cc1d48a7b7fa9c932da439"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later", "LGPL-2.0-or-later", "LGPL-3.0-only"]
  compatibility_version 1

  bottle do
    rebuild 2
    sha256               arm64_tahoe:   "82a2db1df36bfcf2c4646271f8dfb3fc2671a29b2f34d913b673eecdab69805b"
    sha256               arm64_sequoia: "51e1a73949af5075e985a8dba9110d1beb7d82f04bec2cf9eaef597aad71bf5c"
    sha256               arm64_sonoma:  "d63291ccd26bb008d107828313116c1d149f948e447788fdc09665682c8aa102"
    sha256               sonoma:        "3abcf7fbdda68fd20dc4d5f29bfe327a785f5709f869196a6a1ee79203b340a9"
    sha256 cellar: :any, arm64_linux:   "4520c8904d2025498b99f2e27e34f365f3de3facf3fec04f890bdf49dd0cffeb"
    sha256 cellar: :any, x86_64_linux:  "bf08a932ea762aceaef98b8819a76624b73578727f5a98a978d97b0592dd2376"
  end

  keg_only :shadowed_by_macos, "Apple's CLT provides the same tools"

  depends_on "pkgconf" => :build
  depends_on "zstd"

  uses_from_macos "bison" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  skip_clean "etc/ld.so.conf"

  link_overwrite "bin/dwp"

  def install
    args = %W[
      --disable-default-execstack
      --disable-nls
      --disable-werror
      --enable-64-bit-bfd
      --enable-default-hash-style=gnu
      --enable-deterministic-archives
      --enable-multilib
      --enable-new-dtags
      --enable-plugins
      --enable-relro
      --enable-shared
      --enable-targets=all
      --infodir=#{info}
      --mandir=#{man}
      --with-bugurl=#{tap.issues_url}
      --with-system-zlib
      --with-zstd
    ]

    system "./configure", *args, *std_configure_args
    system "make", "tooldir=#{prefix}"
    system "make", "tooldir=#{prefix}", "install"

    # libbfd and libopcodes shouldn't be dynamically linked by external binaries.
    # This modification is similar to the decision made by Arch Linux and Fedora.
    rm([lib/shared_library("libbfd"), lib/shared_library("libopcodes")])

    if OS.mac?
      bin.each_child do |f|
        bin.install_symlink f => "g#{f.basename}"
      end
    else
      # Reduce the size of the bottle.
      bin_files = bin.children.select(&:elf?)
      system "strip", *bin_files, *lib.glob("*.a")

      # Allow ld to find brew glibc. A broken symlink falls back to /etc/ld.so.conf
      (prefix/"etc").install_symlink etc/"ld.so.conf"
    end
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/strings #{bin}/strings")
    assert_predicate prefix/"etc/ld.so.conf", :symlink? if OS.linux?
  end
end
