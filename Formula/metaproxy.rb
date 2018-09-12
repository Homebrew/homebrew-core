class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/metaproxy"
  url "http://ftp.indexdata.dk/pub/metaproxy/metaproxy-1.13.0.tar.gz"
  sha256 "ed3d40058e0e36141bea7d7f0e39733a7b7409281cdf6a60be90186d412c2be1"
  revision 2

  bottle do
    cellar :any
    sha256 "d649f65bafeaac61bbc7c6d2678991e7e13bf6504cd131d300679cb42ac4d18f" => :mojave
    sha256 "58794fbd8dae6368234ef3e912f93e191a822054f9ee195fd4ebaacd9f5a4ad2" => :high_sierra
    sha256 "aefc542879d3df402ba99ae9190801a0f84ad93ea2987e4b82acbceee7a874e7" => :sierra
    sha256 "4bf881091c9caed0fa0f0525f2cd9055df2634357c83fc02269e6abaf493c8a6" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "yazpp"
  depends_on "boost"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
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
