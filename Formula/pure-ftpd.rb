class PureFtpd < Formula
  desc "Secure and efficient FTP server"
  homepage "https://www.pureftpd.org/"
  url "https://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.49.tar.gz"
  sha256 "767bf458c70b24f80c0bb7a1bbc89823399e75a0a7da141d30051a2b8cc892a5"
  revision 1

  livecheck do
    url "https://download.pureftpd.org/pub/pure-ftpd/releases/"
    regex(/href=.*?pure-ftpd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "cbe3995b51f724a6c022bcd2986fc5f1d01c605a08c5f29cd6cc5b4172da5c38"
    sha256 cellar: :any, arm64_big_sur:  "2acbe92870213007b37ca771844c12b211ef8559b08536a2fa371dde91a88565"
    sha256 cellar: :any, monterey:       "709b2b81905bba7e9e43d4b35ab48bc4b898186e950ded42b2e1c8ef0593ecad"
    sha256 cellar: :any, big_sur:        "a9531c95bc19d063436ba9fbaa982abcc2cd990222261530fc824ff50516e8da"
    sha256 cellar: :any, catalina:       "aa0a342b50ae3761120370fc0e6605241e03545441c472d778ef030239784454"
    sha256 cellar: :any, mojave:         "e3a63b9af91de3c29eef40a76d7962cdf8623a8e8992aeb67bdf3948293c450d"
    sha256 cellar: :any, high_sierra:    "a6a9549f3d8bde87cf01210e9fa29b403ed258246a7928d195a57f0c5ace6988"
    sha256 cellar: :any, sierra:         "11dfcec52ae727128c8201a4779fc7feea1d547fe86989a621d4ba339f70de92"
  end

  depends_on "libsodium"
  depends_on "openssl@1.1"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --sysconfdir=#{etc}
      --with-everything
      --with-pam
      --with-tls
      --with-bonjour
    ]

    system "./configure", *args
    system "make", "install"
  end

  service do
    run [opt_sbin/"pure-ftpd", "--chrooteveryone", "--createhomedir", "--allowdotfiles",
         "--login=puredb:#{etc}/pureftpd.pdb"]
    keep_alive true
    working_dir var
    log_path var/"log/pure-ftpd.log"
    error_log_path var/"log/pure-ftpd.log"
  end

  test do
    system bin/"pure-pw", "--help"
  end
end
