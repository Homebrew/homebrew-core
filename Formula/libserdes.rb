class Libserdes < Formula
  desc "Schema ser/deserializer lib for Avro + Confluent Schema Registry"
  homepage "https://github.com/confluentinc/libserdes"
  url "https://github.com/confluentinc/libserdes.git",
  :tag => "v5.3.1"

  bottle do
    cellar :any
  end

  depends_on "avro-c"
  depends_on "librdkafka"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <unistd.h>
      #include <signal.h>
      #include <librdkafka/rdkafka.h>
      #include <serdes-avro.h>
      #include <serdes.h>

      int main()
      {
        rd_kafka_conf_t *rk_conf;
        rk_conf = rd_kafka_conf_new();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/libserdes", "-L/usr/local/lib/", "-L#{lib}", "-lrdkafka", "-lserdes", "-o", "test"
    system "./test"
  end
end
