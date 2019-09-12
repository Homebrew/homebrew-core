class Pound < Formula
  desc "Reverse proxy, load balancer and HTTPS front-end for web servers"
  homepage "http://www.apsis.ch/pound"
  url "http://www.apsis.ch/pound/Pound-2.8.tgz"
  sha256 "a7fd8690de0fd390615e79fd0f4bfd56a544b8ef97dd6659c07ecd3207480c25"

  bottle do
    sha256 "3ac2ac693cb4fdaceec7bd76f53194b52547385d583c798021973b40f9ab951f" => :mojave
    sha256 "2b8c55bbd7d5fd6596766f186289cbb239789b50e1cc9854916107738cc216f6" => :high_sierra
    sha256 "c39e63c7e5e173faf98a8be51df5ec7ea2d3347b912d62cd8b051955b3f75c91" => :sierra
    sha256 "d16c3c0aba3eafe8f50bc4e79401a0ce3129519860d0b3bca8cdfd10023ff7b5" => :el_capitan
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
