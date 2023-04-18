class Binutils < Formula
  desc "GNU binary tools for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.40.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.40.tar.bz2"
  sha256 "f8298eb153a4b37d112e945aa5cb2850040bcf26a3ea65b5a715c83afe05e48a"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later", "LGPL-2.0-or-later", "LGPL-3.0-only"]

  bottle do
    sha256                               arm64_ventura:  "d3d7227d40b30d7582417db8c83ee1283aad077ba9598c39177115b814b36842"
    sha256                               arm64_monterey: "ac7eb45798300a6f551f89a91499978e8bd4513ad1a0678d4bde0cebc2c44398"
    sha256                               arm64_big_sur:  "f5fab4cc241c5d3626aa814793d6326c15569490fb0c35b283a87b51dbea74ed"
    sha256                               ventura:        "71a63f79c6bba9890832277e34718b52fd81d48d02ea04f0f3d08684b7f24d9e"
    sha256                               monterey:       "2181dc01b7fd591ef1882a5ed7ea2af1a6f39d45d907941a4276c2cc4bc873b4"
    sha256                               big_sur:        "45baef2df0508676ffa80404596de47827424e35f5e19bdeb4279a1864c38f5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0917ab2fe7b72350deac1946dd8e937e0199292f05ab763c5f309822c04c195"
  end

  keg_only "it shadows the host toolchain"

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
