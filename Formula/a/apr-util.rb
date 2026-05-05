class AprUtil < Formula
  desc "Companion library to apr, the Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=apr/apr-util-1.6.3.tar.bz2"
  mirror "https://archive.apache.org/dist/apr/apr-util-1.6.3.tar.bz2"
  sha256 "a41076e3710746326c3945042994ad9a4fcac0ce0277dd8fea076fec3c9772b5"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 arm64_tahoe:   "b8b6b9150a95ec16cdbe29a2712842307f1c6d1710d91e526f4e3738e9c49a9f"
    sha256 arm64_sequoia: "9533295fcdcfe68958c5410fe24a2f06e85f9fda26c47e873f7ada59fde464af"
    sha256 arm64_sonoma:  "97126c7077bf1d168412019a2f9a067577212c808e313335bc1d375f6c8cb18d"
    sha256 sonoma:        "1fc4da33f74a570b51daec5004db858f1858c00db8cd69785baa65e9dcf066b6"
    sha256 arm64_linux:   "957fed45ce87cf4252aa3288c042f3b4637936cecf0ff98a62cf32dcaadfcaff"
    sha256 x86_64_linux:  "80b3368cce3bb652c57c617655d52ce77a4d995e6003c4905e2f7e03f231ebaf"
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
    system "./configure", "--with-apr=#{Formula["apr"].opt_prefix}",
                          "--with-crypto",
                          "--with-openssl=#{Formula["openssl@4"].opt_prefix}",
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
