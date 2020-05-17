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
    libexec.install %w[bin etc libexec share]
    rm_rf libexec/"bin/windows"

    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    require "open3"

    assert_match version.to_s, shell_output("#{bin}/kafka-broker-api-versions --version")

    # The executable "confluent" tries to create .confluent under the home directory
    # without considering the envrionment variable "HOME", so the execution will fail
    # due to sandbox-exec.
    # The message "unable to load config" means that the execution will succeed
    # if the user has write permission.
    err, = Open3.capture2e("#{bin}/confluent")
    assert_match /\Aunable to load config/, err
  end
end
