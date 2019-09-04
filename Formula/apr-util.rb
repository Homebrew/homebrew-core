class AprUtil < Formula
  desc "Companion library to apr, the Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=apr/apr-util-1.6.1.tar.bz2"
  sha256 "d3e12f7b6ad12687572a3a39475545a072608f4ba03a6ce8a3778f607dd0035b"
  revision 2

  bottle do
    sha256 "e4927892e16a3c9cf0d037c1777a6e5728fef2f5abfbc0af3d0d444e9d6a1d2b" => :mojave
    sha256 "1bdf0cda4f0015318994a162971505f9807cb0589a4b0cbc7828531e19b6f739" => :high_sierra
    sha256 "75c244c3a34abab343f0db7652aeb2c2ba472e7ad91f13af5524d17bba3001f2" => :sierra
    sha256 "bae285ada445a2b5cc8b43cb8c61a75e177056c6176d0622f6f87b1b17a8502f" => :el_capitan
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
