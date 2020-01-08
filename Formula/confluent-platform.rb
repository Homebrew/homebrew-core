class ConfluentPlatform < Formula
  desc "Developer-optimized distribution of Apache Kafka"
  homepage "https://www.confluent.io/product/confluent-platform/"
  url "https://packages.confluent.io/archive/5.3/confluent-5.3.1-2.12.tar.gz"
  version "5.3.1"
  sha256 "ed18fa2ec2ef00d34b52c9382dc92c9314cf06d2501ab022a62b5ea7ab1010dd"

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
    assert_match version.to_s, shell_output("#{bin}/kafka-broker-api-versions --version")
  end
end
