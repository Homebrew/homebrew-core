class ConfluentOss < Formula
  desc "Developer-optimized distribution of Apache Kafka"
  homepage "https://www.confluent.io/product/confluent-open-source/"
  url "https://packages.confluent.io/archive/5.2/confluent-5.2.0-2.12.tar.gz"
  version "5.2.0"
  sha256 "0b469eabbfe283cbdf8b8f98a2966d3344a95344bc08ca4ca86a6ca52d8cf2d4"

  bottle :unneeded

  depends_on :java => "1.8"

  conflicts_with "kafka", :because => "kafka also ships with identically named Kafka related executables"

  def install
    prefix.install "bin"
    rm_rf "#{bin}/windows"
    prefix.install "etc"
    prefix.install "share"
  end

  test do
    system "#{bin}/confluent", "current"
    assert_match "schema-registry", shell_output("#{bin}/confluent list")
  end
end
