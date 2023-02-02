class AprUtil < Formula
  desc "Companion library to apr, the Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=apr/apr-util-1.6.3.tar.bz2"
  mirror "https://archive.apache.org/dist/apr/apr-util-1.6.3.tar.bz2"
  sha256 "a41076e3710746326c3945042994ad9a4fcac0ce0277dd8fea076fec3c9772b5"
  license "Apache-2.0"

  bottle do
    sha256 arm64_ventura:  "320d7b43f03f9772c4a6ac275ebaedcea7499c7e123cad8260421e5fd6676dbf"
    sha256 arm64_monterey: "372e88baddbf7fe179d6cd2ade929edac4d0e04e67e49d9070c6e0bb4c8fb7d4"
    sha256 arm64_big_sur:  "ef74f0dc5f7c6a48cc878d47b4e5eadf0c25ce8bfd793729a66d3dc1f2a0c18b"
    sha256 ventura:        "58eee2972e5710863062eca49329fddc2b08e478cd1f43aaf22723f2333bc64b"
    sha256 monterey:       "c09fa3ce85e04a55042e267c6d99ea47b979ed3c3fb4cf2c413cb9eae01ee886"
    sha256 big_sur:        "10ec220c162b204c6b13b6ffccef5f1f6de86063b54e44178c20ec27b49410e6"
    sha256 x86_64_linux:   "0301aa6c6e778d6ccf7c332df04ad43aa9cddb4e9ad0e5de09bf2ecd9a0496ab"
  end

  keg_only :shadowed_by_macos, "Apple's CLT provides apr (but not apr-util)"

  depends_on "apr"
  depends_on "openssl@1.1"

  uses_from_macos "expat"
  uses_from_macos "libxcrypt"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "mawk"
    depends_on "unixodbc"
  end

  def install
    system "./configure", *std_configure_args,
                          "--with-apr=#{Formula["apr"].opt_prefix}",
                          "--with-crypto",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--without-pgsql"

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
