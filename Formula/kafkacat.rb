class Kafkacat < Formula
  desc "Generic command-line non-JVM Apache Kafka producer and consumer"
  homepage "https://github.com/edenhill/kafkacat"
  url "https://github.com/edenhill/kafkacat/archive/1.3.0.tar.gz"
  sha256 "1170daa3ec66f32542872fb8a181f021589dc19d510ebc3b141adccc02d2ae5d"

  bottle do
    cellar :any
    sha256 "6a5d1f3ab0c3619b53f88d435f05a2bc6e5ca05a612b3e12d13f85bba7d71517" => :el_capitan
    sha256 "f9cdd267383c3ca532da813bdabd7bf3715e2e22bc078f949a8e12dd4f103f49" => :yosemite
    sha256 "a66d6d312498e117d485d7eea58e412da287be1dc08a1be0cd621d6a77763c7f" => :mavericks
  end

  option "with-yajl", "Adds JSON support"

  depends_on "librdkafka"
  depends_on "yajl" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--enable-json" if build.with?("yajl")

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"kafkacat", "-X", "list"
  end
end
