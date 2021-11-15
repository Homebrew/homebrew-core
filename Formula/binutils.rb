class Binutils < Formula
  desc "GNU binary tools for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.37.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.37.tar.xz"
  sha256 "820d9724f020a3e69cb337893a0b63c2db161dadcb0e06fc11dc29eb1e84a32c"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later", "LGPL-2.0-or-later", "LGPL-3.0-only"]

  bottle do
    sha256 arm64_monterey: "189bea0bf26bbde02e13aa60e16cb7f4fb33c6dc601029393c4c39ee415e5a0a"
    sha256 arm64_big_sur:  "2bf192cb717e8e107e61899218d8d25db92d8c07d164b2dea9c50a3d41b0dca9"
    sha256 monterey:       "feca3b1dbaf91e243e47d261411977909b68b2d54d7e5b1b93c9150a7bc698ad"
    sha256 big_sur:        "9757e5cac1e7fd0046d02671d31f608e57c2398a2d3a0042518707a5fe6fb30c"
    sha256 catalina:       "0c90a75475fc973066ace915f8f58f83bf5009181e42c9c8140dc72453d53d0f"
    sha256 mojave:         "58bf91ff243d080224bd9f7170307788d4319ccdd96d17e7afbf0f326a639f97"
    sha256 x86_64_linux:   "7dcdd47b180a4dfcc838fa0a047f6fbfac0cd37bd867170ac026e6b8ae93af5d"
  end

  keg_only :shadowed_by_macos, "Apple's CLT provides the same tools"

  uses_from_macos "zlib"

  def install
    system "./configure", "--disable-debug",
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
                          "--disable-nls"
    system "make"
    system "make", "install"
    bin.install_symlink "ld.gold" => "gold"
    if OS.mac?
      Dir["#{bin}/*"].each do |f|
        bin.install_symlink f => "g" + File.basename(f)
      end
    else
      # Reduce the size of the bottle.
      system "strip", *Dir[bin/"*", lib/"*.a"]
    end
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/strings #{bin}/strings")
  end
end
