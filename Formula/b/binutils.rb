class Binutils < Formula
  desc "GNU binary tools for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.45.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.45.tar.bz2"
  sha256 "1393f90db70c2ebd785fb434d6127f8888c559d5eeb9c006c354b203bab3473e"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later", "LGPL-2.0-or-later", "LGPL-3.0-only"]

  bottle do
    sha256 arm64_sequoia: "4f7274b8d53163dc1d8dc2b18cc2c7eff75d5efd01db222e7d8bd5f3f05af2c2"
    sha256 arm64_sonoma:  "bcf972b443b276ee59fc94a4c5c84b54d7702ef6bab66b55c811420eaf548dcd"
    sha256 arm64_ventura: "db7f43289bcfffe3c70abef62a1a641671ae8fefb858b654161f7914109286fa"
    sha256 sonoma:        "dfb68055c0d2bddab0e17ab861d76be558877d5f3d960c826fb26a0d59eede14"
    sha256 ventura:       "a1821fba84ee3cbaab966febef3bedc05dc1c1327fadeb768c2f19790c97bf10"
    sha256 arm64_linux:   "f2b26e219cd1a37afbd7743be40ce71525604979d0f7bcdc63fbbce016f4cd4d"
    sha256 x86_64_linux:  "0b5a67a3cfd1779c829a131f38895e1b6c755c57187510cf998f77d4d3a7ddd7"
  end

  keg_only "it shadows the host toolchain"

  depends_on "pkgconf" => :build
  depends_on "zstd"

  uses_from_macos "bison" => :build
  uses_from_macos "zlib"

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
  end

  def post_install
    # Allow ld to find brew glibc when installed on systems that need it
    (prefix/"etc").install_symlink etc/"ld.so.conf" if (etc/"ld.so.conf").exist?
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/strings #{bin}/strings")
  end
end
