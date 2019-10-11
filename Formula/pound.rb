class Pound < Formula
  desc "Reverse proxy, load balancer and HTTPS front-end for web servers"
  homepage "http://www.apsis.ch/pound"
  url "http://www.apsis.ch/pound/Pound-2.8.tgz"
  sha256 "a7fd8690de0fd390615e79fd0f4bfd56a544b8ef97dd6659c07ecd3207480c25"

  bottle do
    cellar :any
    rebuild 1
    sha256 "100b5b65c465f22a925c77479d86206ea964b6b3db03ef3590635b2659626b61" => :catalina
    sha256 "9b2754f632d00c3467017b364d8797b901f648bf5ae482b0131a6792c2d65a19" => :mojave
    sha256 "a2edd6090ff8e6fc56d116b1208fc9d45be9a824c4900f9ea702358b3c843b9b" => :high_sierra
  end

  depends_on "gperftools"
  depends_on "openssl" # no OpenSSL 1.1 support
  depends_on "pcre"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-tcmalloc"
    system "make"
    # Manual install to get around group issues
    sbin.install "pound", "poundctl"
    man8.install "pound.8", "poundctl.8"
  end

  test do
    (testpath/"pound.cfg").write <<~EOS
      ListenHTTP
        Address 1.2.3.4
        Port    80
        Service
          HeadRequire "Host: .*www.server0.com.*"
          BackEnd
            Address 192.168.0.10
            Port    80
          End
        End
      End
    EOS

    system "#{sbin}/pound", "-f", "#{testpath}/pound.cfg", "-c"
  end
end
