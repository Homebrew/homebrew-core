class ConfluentOss < Formula
  desc "Developer-optimized distribution of Apache Kafka"
  homepage "https://www.confluent.io/product/confluent-open-source/"
  url "https://packages.confluent.io/archive/5.1/confluent-oss-5.1.0-2.11.tar.gz"
  version "5.1.0"
  
  sha256 "2b65f4ca70ffa155991530d6ea1f27b9a043b38ecf81ced85a22b527d60b0ea3"
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
