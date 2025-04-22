class Binutils < Formula
  desc "GNU binary tools for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.44.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.44.tar.bz2"
  sha256 "f66390a661faa117d00fab2e79cf2dc9d097b42cc296bf3f8677d1e7b452dc3a"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later", "LGPL-2.0-or-later", "LGPL-3.0-only"]

  bottle do
    sha256                               arm64_sequoia: "d536a93de1561cffb928d198ac1fb48a786baa6ed61cc8e2d0fdc6af5bf72801"
    sha256                               arm64_sonoma:  "72cfbc33daaba41277600107997beb41274f2725ee06e1d335c42209d000aa63"
    sha256                               arm64_ventura: "4101f3e3a14a52f49d9bc7c351b39b906acf62d37dc3d572ed810959a0bfa192"
    sha256                               sonoma:        "70c843be6cdcc54590c4e5a7f27ea5cd2604bfc0cb60eba86e519b9b7420bcf5"
    sha256                               ventura:       "268c62a8bffcb217e0756adf307af666911ab3d9596e660652680363057dc2da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e0554ddadbcca0412f3ee09b452c4fb9c01f6ad0ef3bdc3d28e15b6249c3b5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ea2efa458ca43f31bb2ce2588b8c095849e6145791a2212cec7df1ae873684c"
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

  test do
    assert_match "Usage:", shell_output("#{bin}/strings #{bin}/strings")
  end
end
