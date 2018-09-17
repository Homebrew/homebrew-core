class ActivemqCpp < Formula
  desc "C++ API for message brokers such as Apache ActiveMQ"
  homepage "https://activemq.apache.org/cms/index.html"
  url "https://www.apache.org/dyn/closer.cgi?path=activemq/activemq-cpp/3.9.4/activemq-cpp-library-3.9.4-src.tar.bz2"
  sha256 "6505137fd4835a388b5ddecf6a96a62abd01b6d80f124e95dc2076127f4a84d3"

  bottle do
    cellar :any
    sha256 "61713f3bfd9d2666573a29b7996be2e649bcc713088b08acf5f8ef8f3309d72e" => :mojave
    sha256 "2a78638d0af4698578ef71cf738571ad6cacaef9b8ed2324148eb1df19816885" => :high_sierra
    sha256 "eda1e1feb50e5ffdceb93e3161eab96b389aaa65d64961c6803406176c89f198" => :sierra
    sha256 "799696b515fbff76de2277327d074dc96b74e676df72aa347b23eee12ffbc03b" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "apr"
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
