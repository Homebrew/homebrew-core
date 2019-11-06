class AprUtil < Formula
  desc "Companion library to apr, the Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=apr/apr-util-1.6.1.tar.bz2"
  sha256 "d3e12f7b6ad12687572a3a39475545a072608f4ba03a6ce8a3778f607dd0035b"
  revision 3

  bottle do
    sha256 "425955a21c3fec8e78f365cd7fc4c6c4ec95d074f720a9b24e8237af90cc4dcc" => :catalina
    sha256 "b3b8376d8f481164a34b891b926ab22acdc2903e77c4cfbc04c0ba6363ca7597" => :mojave
    sha256 "20688bea4981567848393aeeb1964f2200847f63ee52eb8c68d8fff0e4dd8b45" => :high_sierra
    sha256 "16e812e4be2247d8e8f4f8a68ba6765ceb5a98e22a08dda288eb99dff2e41ae0" => :sierra
  end

  keg_only :provided_by_macos, "Apple's CLT package contains apr"

  depends_on "apr"
  depends_on "openssl@1.1"

  def install
    # Install in libexec otherwise it pollutes lib with a .exp file.
    system "./configure", "--prefix=#{libexec}",
                          "--with-apr=#{Formula["apr"].opt_prefix}",
                          "--with-crypto",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--without-pgsql"

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
