class Gold < Formula
  desc "GNU gold linker"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.39.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.39.tar.xz"
  sha256 "645c25f563b8adc0a81dbd6a41cffbf4d37083a382e02d5d3df4f65c09516d00"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later", "LGPL-2.0-or-later", "LGPL-3.0-only"]

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4403d82e91e8c3bfa8811845863ce5b7167175073928e4192c70b5aefdaf1eea"
  end

  depends_on :linux

  uses_from_macos "zlib"

  def install
    args = [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--enable-deterministic-archives",
      "--prefix=#{prefix}",
      "--infodir=#{info}",
      "--mandir=#{man}",
      "--disable-werror",
      "--enable-gold",
      "--enable-interwork",
      "--enable-multilib",
      "--enable-plugins",
      "--enable-targets=all",
      "--with-system-zlib",
      "--disable-nls",
    ]

    system "./configure", *args
    # Pass MAKEINFO=true to disable generation of HTML documentation.
    # This avoids a build time dependency on texinfo.
    system "make", "all-gold", "MAKEINFO=true"
    system "make", "install-gold", "MAKEINFO=true"
    bin.install_symlink "ld.gold" => "gold"
    system "strip", *bin.children, *lib.glob("*.a")
  end

  test do
    assert_match "fatal error: no input files", shell_output("#{bin}/gold 2>&1", 1)
  end
end
