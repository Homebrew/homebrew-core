class ConfluentPlatform < Formula
  desc "Developer-optimized distribution of Apache Kafka"
  homepage "https://www.confluent.io/product/confluent-platform/"
  url "https://packages.confluent.io/archive/5.3/confluent-5.3.0-2.12.tar.gz"
  version "5.3.0"
  sha256 "b7e21e09fcbdd5f6695352b0e308ef276acd8d54041440e4f66545370ca69191"

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
    system "#{bin}/kafka-broker-api-versions", "--version"
    assert_match "5.3.0", shell_output("#{bin}/kafka-broker-api-versions --version")
  end
end
