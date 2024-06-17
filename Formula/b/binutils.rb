class Binutils < Formula
  desc "GNU binary tools for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.42.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.42.tar.bz2"
  sha256 "aa54850ebda5064c72cd4ec2d9b056c294252991486350d9a97ab2a6dfdfaf12"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later", "LGPL-2.0-or-later", "LGPL-3.0-only"]

  bottle do
    sha256                               arm64_sonoma:   "8b153634be5a4d45e711e1bd44be8fd1812995c96a80780889bb9b199b634651"
    sha256                               arm64_ventura:  "33259f49dae5f8af03f37e20bf0cd2fa9f1275cb02595465c6a9685a678487cd"
    sha256                               arm64_monterey: "1c9af3920c25dd2dc920c86ccb6e88eb6de36f06b1a8e54853ee4077a6deb757"
    sha256                               sonoma:         "2049b9d2bbe5f8dc584eaaaac3eca5bce12cce71eafa5278970a91df31a5484c"
    sha256                               ventura:        "befaac62997689c67f14119fe4ae5f0639752c06ee35d36babb47c0af0b7e3b5"
    sha256                               monterey:       "28bbb03f61999414bb5fe49a1bc706f4df32bcb5906b019d4337b0d8e454ab0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b498d741c952477f46dc6a2f46f91ace4e65579c56c419188f25e3e792d959a"
  end

  keg_only "it shadows the host toolchain"

  depends_on "pkg-config" => :build
  depends_on "zstd"

  uses_from_macos "bison" => :build
  uses_from_macos "zlib"

  link_overwrite "bin/gold"
  link_overwrite "bin/ld.gold"
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
      "--enable-gold",
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
      bin.install_symlink "ld.gold" => "gold"
      # Reduce the size of the bottle.
      bin_files = bin.children.select(&:elf?)
      system "strip", *bin_files, *lib.glob("*.a")
    end
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/strings #{bin}/strings")
  end
end
