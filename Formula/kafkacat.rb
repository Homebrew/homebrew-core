class Kafkacat < Formula
  desc "Generic command-line non-JVM Apache Kafka producer and consumer"
  homepage "https://github.com/edenhill/kafkacat"
  url "https://github.com/edenhill/kafkacat.git",
      :tag => "1.3.0",
      :revision => "b79896cceedf81df7873850f38e5e2c4ad3e3e57"
  revision 2

  bottle do
    cellar :any
    sha256 "d6d0216bf1ea263494f9286e90bc965e9009fd05227d201d0bee0afb0ccebaac" => :sierra
    sha256 "f3e04c8005e9bd353717c04be4191bd1404385fb6e502ae6f52402e95b73189f" => :el_capitan
    sha256 "19bc3da24e213841b428fa755a9b259c6132eba3181b03c4ac5eff116ba8702b" => :yosemite
  end

  depends_on "librdkafka"
  depends_on "yajl"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-json
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"kafkacat", "-X", "list"
  end
end
