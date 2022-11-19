class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.32.0.tar.gz"
  sha256 "1077052d4c4e848ac47d14f9b37754d46419aecbe8c9a07e1f869c914faf3216"
  license "AGPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://mmonit.com/monit/dist/"
    regex(/href=.*?monit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "d96d0558c3c18acd5e6039e444cc6b4c7691f0b3cf33b3a5b9cc2e15b1acb000"
    sha256 cellar: :any,                 arm64_monterey: "6577cddf4bd40aafdee0089655c5ed177741b5eddbd9a4d1344b8a6029904809"
    sha256 cellar: :any,                 arm64_big_sur:  "d6a37cfb90af7e29627e67a46830e91c98c249ff10855f4d6fd6a101864a1e8c"
    sha256 cellar: :any,                 monterey:       "599096912baee50637670137f35a9cf198789aaeee93ccfe6551868a804f09e9"
    sha256 cellar: :any,                 big_sur:        "00908f29d92ea3837ed418d61f080bffb89b4c7ec01aa36348089d922e02064f"
    sha256 cellar: :any,                 catalina:       "c6c5818e4668c4cf0383770b19ffa5baef9ce12735cbc3f3fc8d1724125c981a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b96f96e6d435b0c083593c797e4bb424a683ec6fa13aca4401d7a5a9226b05c"
  end

  depends_on "openssl@3"

  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}/monit",
                          "--sysconfdir=#{etc}/monit",
                          "--with-ssl-dir=#{Formula["openssl@3"].opt_prefix}"
    system "make"
    system "make", "install"
    etc.install "monitrc"
  end

  service do
    run [opt_bin/"monit", "-I", "-c", etc/"monitrc"]
  end

  test do
    system bin/"monit", "-c", "#{etc}/monitrc", "-t"
  end
end
