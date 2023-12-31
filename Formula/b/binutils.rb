class Binutils < Formula
  desc "GNU binary tools for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.41.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.41.tar.bz2"
  sha256 "a4c4bec052f7b8370024e60389e194377f3f48b56618418ea51067f67aaab30b"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later", "LGPL-2.0-or-later", "LGPL-3.0-only"]
  revision 1

  bottle do
    sha256                               arm64_sonoma:   "7a166675c290aace1279c989cc124864d94f37dcfc80689e50f109eea7da78be"
    sha256                               arm64_ventura:  "4a3eaa83c0f31868d2268122a13cb805f89b4b14a65fbf2d35558eeeb960d040"
    sha256                               arm64_monterey: "0fc9e683eecf173585c23fbf096010e28b06bd88c6e2eff9e9d9f4154c48e4e5"
    sha256                               sonoma:         "c5d6ca6fcba7d2e507f4c3115983b73de80c5558e5c2afd83411333b7585c044"
    sha256                               ventura:        "f23fd169d4598b0ced42b1f8b91573ef5ca64dd3df8919e94521b3037be626cc"
    sha256                               monterey:       "77d558422dc8f2d2c517c9256282fba322a55946dfee68775e0063079c745511"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff5d14a01dbfc4e423713561d02e704b90577eb32feb7ee276b1a4065eb05a47"
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
