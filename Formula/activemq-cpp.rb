class ActivemqCpp < Formula
  desc "C++ API for message brokers such as Apache ActiveMQ"
  homepage "https://activemq.apache.org/cms/index.html"
  url "https://www.apache.org/dyn/closer.cgi?path=activemq/activemq-cpp/3.9.3/activemq-cpp-library-3.9.3-src.tar.bz2"
  sha256 "d7554c6245f7a5f96e8b9751a562f841ee285777487ccfbca1bfd74db024b50e"

  bottle do
    cellar :any
    sha256 "ba85affa7a01c8ae45beb27545c841bc4f57f0c2841e4533dc537d6abe3a6486" => :el_capitan
    sha256 "be16c11110621a32d65a7843f05813cfc7c6861ea589a076699e5f66bf6b2a02" => :yosemite
    sha256 "0180da693b7e8a478538393e8746c0ffb1dc0904e24cceb4be591230c7004bf2" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/activemqcpp-config", "--version"
  end
end
