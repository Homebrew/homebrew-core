class AprUtil < Formula
  desc "Companion library to apr, the Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=apr/apr-util-1.6.5.tar.bz2"
  mirror "https://archive.apache.org/dist/apr/apr-util-1.6.5.tar.bz2"
  sha256 "96de1dd6f6a0476d2d2e7964926d8c1ddc3bb0e210e1b1812d3ba5a454a392e2"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 arm64_golden_gate: "ad199dc3a5579906d061fdde92fa50568967d01c5766a2e0881b18f5e77cf894"
    sha256 arm64_tahoe:       "22e6ad6d2811495d5c5467e56c64e710b093e36f2141e4490b0e65d4ffaa59fe"
    sha256 arm64_sequoia:     "9e16cae0d49d057a60f8f611bfd77757229bfafb36dcbe61b14893ddb285883c"
    sha256 arm64_linux:       "5a339e9ac46c40b11acd4c009881fbcd62509a7419a025928a035a9e591c136b"
    sha256 x86_64_linux:      "797b9cf4b25eab090db9255f7eaf5080ef2c5ced3ca2153631eb4e65475e626e"
  end

  keg_only :shadowed_by_macos, "Apple's CLT provides apr (but not apr-util)"

  depends_on "apr"
  depends_on "openssl@4"

  uses_from_macos "expat"
  uses_from_macos "libxcrypt"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "unixodbc"
  end

  def install
    system "./configure", "--with-apr=#{formula_opt_prefix("apr")}",
                          "--with-crypto",
                          "--with-openssl=#{formula_opt_prefix("openssl@4")}",
                          "--without-pgsql",
                          *std_configure_args
    system "make"
    system "make", "install"

    # Install symlinks so that linkage doesn't break for reverse dependencies.
    # This should be removed on the next ABI breaking update.
    (libexec/"lib").install_symlink Dir["#{lib}/#{shared_library("*")}"]

    rm Dir[lib/"**/*.{la,exp}"]

    # No need for this to point to the versioned path.
    inreplace bin/"apu-#{version.major}-config", prefix, opt_prefix
  end

  test do
    assert_match opt_prefix.to_s, shell_output("#{bin}/apu-#{version.major}-config --prefix")
  end
end
