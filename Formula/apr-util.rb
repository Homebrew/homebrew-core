class AprUtil < Formula
  desc "Companion library to apr, the Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=apr/apr-util-1.6.3.tar.bz2"
  mirror "https://archive.apache.org/dist/apr/apr-util-1.6.3.tar.bz2"
  sha256 "a41076e3710746326c3945042994ad9a4fcac0ce0277dd8fea076fec3c9772b5"
  license "Apache-2.0"

  bottle do
    sha256 arm64_ventura:  "6934399a13fd918d1b923b0f3c11b147b7f95252fb5346e6c2c1ff0ea469dd47"
    sha256 arm64_monterey: "b9f49b64bb09ebbacca86db8b043eeae0d4ccbdbbc107387ac62940a0813c8b2"
    sha256 arm64_big_sur:  "ccb19102ab96bc0ca3575931a34ebfbb8313fddd03c91d6379316f80174a84be"
    sha256 ventura:        "0ed3fd969da7b5199386e5ad2da2c1585c273c4e9bfc3d601b3cb12984ca298a"
    sha256 monterey:       "5bcb46d9d71cfbbcd247ead2d3eb47d587397cfd7c2c34ea5f3f855bc06985c5"
    sha256 big_sur:        "12b7c6a3247bd7fcf1c8f240e7d1b94f1d6303ac065583806a8ac895353ac452"
    sha256 x86_64_linux:   "8cee1baa7025531d181d2c6a49198f2095b043405ddbb8618ae9e5e36c2713fb"
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
