class AprUtil < Formula
  desc "Companion library to apr, the Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=apr/apr-util-1.6.1.tar.bz2"
  sha256 "d3e12f7b6ad12687572a3a39475545a072608f4ba03a6ce8a3778f607dd0035b"
  revision 2

  bottle do
    rebuild 1
    sha256 "bdc898744b7e570af5bf04a964d216e75285cce455b125e1d9b0df1510e3bdbf" => :mojave
    sha256 "8da18e2dce508adbd19b2330cc8cc822a73c3d282fec7061e430a5edf6728d02" => :high_sierra
    sha256 "2b8fe46f5c4c9e53c3727e4221f4189a5c27621c60c56518fc0c259ed0ebfa04" => :sierra
  end

  keg_only :provided_by_macos, "Apple's CLT package contains apr"

  depends_on "apr"
  depends_on "openssl@1.1"

  def install
    # Install in libexec otherwise it pollutes lib with a .exp file.
    system "./configure", "--prefix=#{libexec}",
                          "--with-apr=#{Formula["apr"].opt_prefix}",
                          "--with-crypto",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make"
    system "make", "install"
    bin.install_symlink Dir["#{libexec}/bin/*"]

    rm Dir[libexec/"lib/*.la"]
    rm Dir[libexec/"lib/apr-util-1/*.la"]

    # No need for this to point to the versioned path.
    inreplace libexec/"bin/apu-1-config", libexec, opt_libexec
  end

  test do
    assert_match opt_libexec.to_s, shell_output("#{bin}/apu-1-config --prefix")
  end
end
