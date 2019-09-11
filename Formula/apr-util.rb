class AprUtil < Formula
  desc "Companion library to apr, the Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=apr/apr-util-1.6.1.tar.bz2"
  sha256 "d3e12f7b6ad12687572a3a39475545a072608f4ba03a6ce8a3778f607dd0035b"
  revision 2

  bottle do
    sha256 "4fdaae0a455c73ac9240d24385bac3f4513ebc3aad7b0b3baffa1a7078f025cb" => :mojave
    sha256 "0cbb41851d5e0d2bf309b5ee079b27695c6b4529b6681f1f1aab1c1f5abd544e" => :high_sierra
    sha256 "ceb8bef2d0e292a3975ae941da686a21319fa3b9b45700fce703eaeb683c6bd8" => :sierra
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
