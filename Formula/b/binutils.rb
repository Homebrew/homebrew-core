class Binutils < Formula
  desc "GNU binary tools for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.43.1.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.43.1.tar.bz2"
  sha256 "becaac5d295e037587b63a42fad57fe3d9d7b83f478eb24b67f9eec5d0f1872f"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later", "LGPL-2.0-or-later", "LGPL-3.0-only"]

  bottle do
    sha256                               arm64_sequoia:  "c645c3616086c374d30a1f3c1c6001f6f2562198efdf7ffea7d081eb33e36449"
    sha256                               arm64_sonoma:   "88c34d875602f7bce1ad098b0dc61df8018db8febcd8a6d4759971cae74403d7"
    sha256                               arm64_ventura:  "79dc9dfa4c4af46fe047c8c362c2cbad169d5d4c6c7d21d105e23ed1411ac3cd"
    sha256                               arm64_monterey: "f46062326982276204aa358adc611d074b5872951678bb06a82fe399b7929b4a"
    sha256                               sonoma:         "c88cb916d41507aed43ffe00cfbea11069e86ef78eb997db9ca7da1a48312f98"
    sha256                               ventura:        "63bd99b78b6df776b633ed15439abd116afdd1a2b29e392191e37efaa58a3657"
    sha256                               monterey:       "809e8a094c8bd8c03fee89af3d50a5837644b1af6184754d732981e628be98a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab5913dd80970340737b8450c3d227f2e6ad07874c240a82d1749ff4bba8b863"
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
