class Kcat < Formula
  desc "Generic command-line non-JVM Apache Kafka producer and consumer"
  homepage "https://github.com/edenhill/kcat"
  url "https://github.com/edenhill/kcat.git",
      tag:      "1.7.0",
      revision: "f2236ae5d985b9f31631b076df24ca6c33542e61"
  license "BSD-2-Clause"
  head "https://github.com/edenhill/kcat.git", branch: "master"

  depends_on "avro-c"
  depends_on "librdkafka"
  depends_on "libserdes"
  depends_on "yajl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-json",
                          "--enable-avro"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"kcat", "-X", "list"
  end
end
