class Binutils < Formula
  desc "GNU binary tools for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.46.0.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.46.0.tar.bz2"
  sha256 "0f3152632a2a9ce066f20963e9bb40af7cf85b9b6c409ed892fd0676e84ecd12"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later", "LGPL-2.0-or-later", "LGPL-3.0-only"]

  bottle do
    sha256                               arm64_tahoe:   "274e1e41ddb008e2089fe5faaa832a0383abdda48acf26134ee59510cb8aac63"
    sha256                               arm64_sequoia: "79e6d99c1d38ad33264131e8a7cc37e897416aeb39a099a62dd92f3c09fc59bd"
    sha256                               arm64_sonoma:  "b2e3b4aa403f52a721ccd90ec6b71fdb0546280f20dfc117d158e6de527fdfc3"
    sha256                               sonoma:        "9f4c9c9923a27f2be826e8d20d16ff9c1de50cd87aab5b10a1bd0e2641028d5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8ffe8d70c5462a8cd0364aa70ceb484707683e1a87e2f56d8315820ddf5beb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "016d03201f1fa5f3c65a17a041f176f2e9037ae6a9c888dcad56b4710aa629c1"
  end

  keg_only "it shadows the host toolchain"

  depends_on "pkgconf" => :build
  depends_on "zstd"

  uses_from_macos "bison" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  skip_clean "etc/ld.so.conf"

  link_overwrite "bin/dwp"

  def install
    # Workaround https://sourceware.org/bugzilla/show_bug.cgi?id=28909
    touch "gas/doc/.dirstamp", mtime: Time.utc(2022, 1, 1)
    make_args = OS.mac? ? [] : ["MAKEINFO=true"] # for gprofng

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
