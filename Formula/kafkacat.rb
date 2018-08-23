class Kafkacat < Formula
  desc "Generic command-line non-JVM Apache Kafka producer and consumer"
  homepage "https://github.com/edenhill/kafkacat"
  url "https://github.com/edenhill/kafkacat.git",
      :tag => "1.3.1",
      :revision => "0ab52045cde0c16f9f99dad41cee019ff88e974e"
  revision 1

  bottle do
    cellar :any
    sha256 "faaf8dfca36c061b0ef0be2c42fafd5cc426198dec0762238d10fd216409bdad" => :mojave
    sha256 "d38492eb3083e50f91bb50d0a77c59bf559821a6dbc958b3b8d3bac4b192dead" => :high_sierra
    sha256 "14038aa18ab2f7f982000b3a5ad347f9519809b3bab0cfe47424bb73f333de6e" => :sierra
    sha256 "ef21329872a809c9a01e6361fcc2d0830f5b9c33455286260b45713acf19285f" => :el_capitan
    sha256 "cc9011d799bd2dfcb514c9ac499bda051e14a30f73ea8884048fa3d1337ceb47" => :yosemite
  end

  depends_on "librdkafka"
  depends_on "yajl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-json"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"kafkacat", "-X", "list"
  end
end
