class ConfluentOss < Formula
  desc "Developer-optimized distribution of Apache Kafka"
  homepage "https://www.confluent.io/product/confluent-open-source/"
  url "https://packages.confluent.io/archive/5.1/confluent-5.1.2-2.11.tar.gz"
  version "5.1.2"
  sha256 "dceea4333367b4513f971a78064bec9a12b977bb309957e1d4e863f9aae3dac0"

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
