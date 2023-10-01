class Binutils < Formula
  desc "GNU binary tools for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.41.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.41.tar.bz2"
  sha256 "a4c4bec052f7b8370024e60389e194377f3f48b56618418ea51067f67aaab30b"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later", "LGPL-2.0-or-later", "LGPL-3.0-only"]

  bottle do
    sha256                               arm64_sonoma:   "f98e4acb81431b57e3c253950988f7812a79331e516491090a1d5f6a1b942be2"
    sha256                               arm64_ventura:  "dd11d10f267c8196dbb674ac48097f1dd985f17044da871d5107285840ef0389"
    sha256                               arm64_monterey: "44ac008047f579b2a2edbd5c5eafa845c6cf03b4a9ccf599e8244ebf45c44439"
    sha256                               arm64_big_sur:  "af0a54bbc41ba01f9aa5ef2e9445df7c420541d22abc128a4b4fd0828cefe89b"
    sha256                               sonoma:         "b48590d03751409c6499ef0d18575343eb2f43dde058dc39a6f9edbac9c5b4f3"
    sha256                               ventura:        "a8fd0d420a9a610164e0a548aa0e36fafea2c272f0d16a923e4e5f9ac50f77ec"
    sha256                               monterey:       "cbec0ebe80a44a74156c8ee85375d0b9c38170947a3456e1819cc90993279e9d"
    sha256                               big_sur:        "5cb102e7ee7289e2f9b1e87ab7e1322718624e1e27f6641568943250fa65c797"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b91a59270365b124e3d73d14d75c9085f156f9b521b94387793b91cff1f98c3"
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
