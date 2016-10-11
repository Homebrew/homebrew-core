class Kafkacat < Formula
  desc "Generic command-line non-JVM Apache Kafka producer and consumer"
  homepage "https://github.com/edenhill/kafkacat"
  url "https://github.com/edenhill/kafkacat/archive/1.3.0.tar.gz"
  sha256 "1170daa3ec66f32542872fb8a181f021589dc19d510ebc3b141adccc02d2ae5d"

  bottle do
    cellar :any
    sha256 "25a5f4adac93dba85de1681b79ff87d923eb5a1a95582853e92cd70a22c83c4d" => :sierra
    sha256 "632efceabc31814305eb5331bc25a361414afd9ef1562cb9bb6463526997bb5e" => :el_capitan
    sha256 "32bcf9d514f4e566029b3427098c6d73f78dad911fd6b762e38395c1ef41edb8" => :yosemite
    sha256 "c1dcf8abd6c4917950403a872bca4d0502a116dfdfb0eb29c950f03a120ada6f" => :mavericks
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
