class Binutils < Formula
  desc "GNU binary tools for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.46.1.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.46.1.tar.bz2"
  sha256 "324ed40ada2633a28eaa5d104ca5db165fd3cc3162cc1d48a7b7fa9c932da439"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later", "LGPL-2.0-or-later", "LGPL-3.0-only"]
  compatibility_version 1

  bottle do
    sha256               arm64_tahoe:   "0fa7427cfdd1f13ed418e1c0b68a6ccd0bec6a42a332fdcbca082f86c2f41df0"
    sha256               arm64_sequoia: "0718674cdd51382532b1380b172b52c0083faad78aad689192a85c3d63f66cd0"
    sha256               arm64_sonoma:  "d59df6b8728e9b2b74f92e4613a3351e0bbb728cc76037c1a7ba1bea2c323a6e"
    sha256               sonoma:        "fb1e98cfd6d046d05f13648231a8bc59576927120def25ba1315a49d6b9b972c"
    sha256 cellar: :any, arm64_linux:   "668e2da50d0cabc4c3a5d09c31e19a2ae7e3aec3b33980254a6a54a943e32e58"
    sha256 cellar: :any, x86_64_linux:  "3fa1925f8132d50e5602c543637c04b7dd7e50370b1ad7715da8458f2f99e71a"
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
      --enable-deterministic-archives
      --infodir=#{info}
      --mandir=#{man}
      --disable-werror
      --enable-interwork
      --enable-multilib
      --enable-64-bit-bfd
      --enable-plugins
      --enable-targets=all
      --with-system-zlib
      --with-zstd
      --disable-nls
    ]
    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"

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
