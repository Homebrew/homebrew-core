class Binutils < Formula
  desc "GNU binary tools for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.45.1.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.45.1.tar.bz2"
  sha256 "860daddec9085cb4011279136fc8ad29eb533e9446d7524af7f517dd18f00224"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later", "LGPL-2.0-or-later", "LGPL-3.0-only"]

  bottle do
    sha256                               arm64_tahoe:   "787eb646984cfe01e0febce0934328284bd625c857000f7e26dd2fe321594570"
    sha256                               arm64_sequoia: "58b610e8445a31be5a7319a146b38b42201f8d38311923e7c08e968927f3e9b9"
    sha256                               arm64_sonoma:  "e7ebe50b0baeb016f9d19574441b39d282999c4e987c0c957982ef859f399355"
    sha256                               sonoma:        "71b7c0860d54ad4044545dfe71d64e9ca4edce86d3b538d1e8bbc8509e57d6c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4a3aeddde228c29e66dc501b2a313856f4fb5f3d56b529484964bd26896e0ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e7a7d7a7f35c5a04d04539d9454e62e59dc3a03849ad00c01d97b4289faef90"
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
