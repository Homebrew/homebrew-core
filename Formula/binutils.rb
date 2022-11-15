class Binutils < Formula
  desc "GNU binary tools for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.39.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.39.tar.xz"
  sha256 "645c25f563b8adc0a81dbd6a41cffbf4d37083a382e02d5d3df4f65c09516d00"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later", "LGPL-2.0-or-later", "LGPL-3.0-only"]
  revision 1

  bottle do
    sha256                               arm64_ventura:  "75133dcb211cfe242e392be4c40164fb0ea56eba53ef5e717d3a3c49f5242b1c"
    sha256                               arm64_monterey: "758ad6292041c3c53918b9177f30a5a15acfb3868cbc51d79dc51fcc5a661a4c"
    sha256                               arm64_big_sur:  "93b1cfd89c43d8822fd6f78d4a573425891193e46de5cb3b86658db4f8f868dd"
    sha256                               ventura:        "55e8eb0e3d5946892f5f5832a2e7a8fd4f7ea7cecbe76e1c2bab1b69e2a4e019"
    sha256                               monterey:       "2ec016569ad18525d8f0598f2f6d42e4fb8b0e02178484acc3e885b381789a9b"
    sha256                               big_sur:        "8842e0decbce5fe9718f492648730163ac9aa0cca4ccd08ec700ef95d0e07761"
    sha256                               catalina:       "17e7dbd79aeaa50547888612f741c427a682fb269f6796345abd01710b89abcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efa7497e2ea56d9b68ce41363cdc1a41cad032b3ae2fa2cbe819459011651809"
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
