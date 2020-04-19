class ConfluentPlatform < Formula
  desc "Developer-optimized distribution of Apache Kafka"
  homepage "https://www.confluent.io/product/confluent-platform/"
  url "https://packages.confluent.io/archive/5.4/confluent-5.4.1-2.12.tar.gz"
  version "5.4.1"
  sha256 "3a0fb84e9b22f91eead27490840c2c21d79778ecf1c69ae9d8bbe44ee0f5e48b"

  bottle :unneeded

  depends_on :java => "1.8"

  conflicts_with "kafka", :because => "kafka also ships with identically named Kafka related executables"

  def install
    prefix.install "bin"
    rm_rf "#{bin}/windows"
    prefix.install "etc"
    prefix.install "libexec"
    prefix.install "share"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kafka-broker-api-versions --version")

    home = ENV["HOME"]
    system "echo", "#{home}/.confluent"
    system "mkdir", "#{home}/.confluent/"
    system "ls", "#{home}/.confluent"

    ENV["CONFLUENT_HOME"] = "/usr/local/Cellar/confluent-platform/5.4.1/"
    system "#{bin}/confluent", "--version"
    assert_equal "0\n", shell_output("echo $?")
    home = ENV["HOME"]
    system "echo", "#{home}/.confluent"
  end
end
