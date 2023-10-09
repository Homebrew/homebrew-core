class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/resources/software/metaproxy/"
  url "https://ftp.indexdata.com/pub/metaproxy/metaproxy-1.21.0.tar.gz"
  sha256 "874223a820b15ee2626240c378eee71e31a4e6d3498a433c94409c949e654fae"
  license "GPL-2.0-or-later"
  revision 1

  # The homepage doesn't link to the latest source file, so we have to check
  # the directory listing page directly.
  livecheck do
    url "https://ftp.indexdata.com/pub/metaproxy/"
    regex(/href=.*?metaproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2299016e0b81ae308aa417a856aa69afd5e05429895bf08bd2defea09d325432"
    sha256 cellar: :any,                 arm64_ventura:  "2c39998f77952b5a09b6869f82895af7be109ad7bcf85235e2687302b7e7da7e"
    sha256 cellar: :any,                 arm64_monterey: "dcad5af967b3aea05d0c2716abb421e398458ae45424f8b4f5b5cb6bdab66762"
    sha256 cellar: :any,                 arm64_big_sur:  "75ef8bba6fdf29e2ff25ede0180e33ccaf5ecdf77057ace160055d61c9a02b88"
    sha256 cellar: :any,                 sonoma:         "10d49a0163efd5a3cd1284df1c8b7efa49986981ae2e3a721fb72a53d34379c0"
    sha256 cellar: :any,                 ventura:        "53a9d7795665a872e74651f9600428d53b63605028d850b3c9cda02686ddff30"
    sha256 cellar: :any,                 monterey:       "b08581aa2833dca73cf699fd4c9910a575cf097113f8d78655cff7f680fa57b0"
    sha256 cellar: :any,                 big_sur:        "6316f51dfc9500d525be283e8d0c02724a9ab7270cc31ae5a200fb5d7b631c0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c45c4c7615c434ea2276608fc8df307554652f95d3a80060ca54aa592b6b4f9"
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "yazpp"

  fails_with gcc: "5"

  def install
    # Match C++ standard in boost to avoid undefined symbols at runtime
    # Ref: https://github.com/boostorg/regex/issues/150
    ENV.append "CXXFLAGS", "-std=c++14"

    system "./configure", *std_configure_args
    system "make", "install"
  end

  # Test by making metaproxy test a trivial configuration file (etc/config0.xml).
  test do
    (testpath/"test-config.xml").write <<~EOS
      <?xml version="1.0"?>
      <metaproxy xmlns="http://indexdata.com/metaproxy" version="1.0">
        <start route="start"/>
        <filters>
          <filter id="frontend" type="frontend_net">
            <port max_recv_bytes="1000000">@:9070</port>
            <message>FN</message>
            <stat-req>/fn_stat</stat-req>
          </filter>
        </filters>
        <routes>
          <route id="start">
            <filter refid="frontend"/>
            <filter type="log"><category access="false" line="true" apdu="true" /></filter>
            <filter type="backend_test"/>
            <filter type="bounce"/>
          </route>
        </routes>
      </metaproxy>
    EOS

    system "#{bin}/metaproxy", "-t", "--config", "#{testpath}/test-config.xml"
  end
end
