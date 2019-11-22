class Kafkacat < Formula
  desc "Generic command-line non-JVM Apache Kafka producer and consumer"
  homepage "https://github.com/edenhill/kafkacat"
  url "https://github.com/edenhill/kafkacat.git",
      :tag      => "1.5.0",
      :revision => "3b4bcf00d322533c374e226f2a4eb16501e8a441"

  bottle do
    cellar :any
    sha256 "cc01ec929d214eedcec98151842b38587f35e986436f5bb1cabe64d836627beb" => :catalina
    sha256 "c3b196b7c491b9640c268591df790f89d5c12c6551e54f49a39193bdf100eea9" => :mojave
    sha256 "13717f4c5cc332fda009d2cafba1433414e6c2def7c3131129f8d2e4a8dab307" => :high_sierra
    sha256 "e09845976996cd838656e0065309e06f65e8446e1f0eb01f471bda2da36553ed" => :sierra
  end

  depends_on "librdkafka"
  depends_on "yajl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-json"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"kafkacat", "-X", "list"
  end
end
