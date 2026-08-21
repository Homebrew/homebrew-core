class Binutils < Formula
  desc "GNU binary tools for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.47.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.47.tar.bz2"
  sha256 "3068128c75cda9f898ccb4211d360246e8e195ffcc9dfb655b23ae23a54800e8"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later", "LGPL-2.0-or-later", "LGPL-3.0-only"]
  compatibility_version 1

  bottle do
    sha256               arm64_tahoe:   "3453a1b0d79fcf2f8cdb994352a7a0c42f075027df3c5af9cd3b59e48d925217"
    sha256               arm64_sequoia: "d5a0fc7a1ecde47af381298523ee64c9072041531634e405e2adac034d73095d"
    sha256               arm64_sonoma:  "8ffc2a8bcba52c6a839432faeeab5fff00beb60bd7d9c4bf26cfa057e595ebaf"
    sha256               sonoma:        "eb444e609e4d81b3f61af7fb251fda61c3a1980cc7c0461c6e9cee1c240af2c9"
    sha256 cellar: :any, arm64_linux:   "09c7c1414fee9ff82848c4e7711fce85d2506555dd4a62a3d69e199736cb5113"
    sha256 cellar: :any, x86_64_linux:  "69509d3a474bc6c043fdc1e50a447b973813d8646405bcbbb764a4935696b1b7"
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
