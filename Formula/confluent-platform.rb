class ConfluentPlatform < Formula
  desc "Developer-optimized distribution of Apache Kafka"
  homepage "https://www.confluent.io/product/confluent-platform/"
  url "https://packages.confluent.io/archive/5.5/confluent-5.5.1-2.12.tar.gz"
  version "5.5.1"
  sha256 "60efb18fb5768d05bbe7d0194fc6b61018ea3bd562d8829f9b14d9b5dd35f790"

  bottle :unneeded

  depends_on java: "1.8"

  conflicts_with "kafka", because: "kafka also ships with identically named Kafka related executables"

  def install
    libexec.install %w[bin etc libexec share]
    rm_rf libexec/"bin/windows"

    # Delete some lines to avoid the error like
    # "cd: ../Cellar/confluent-platform/5.5.0/bin/../share/java: No such file or directory"
    inreplace libexec/"bin/confluent-hub", "[ -L /usr/local/bin/confluent-hub ]", "false"

    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kafka-broker-api-versions --version")

    # The executable "confluent" tries to create .confluent under the home directory
    # without considering the envrionment variable "HOME", so the execution will fail
    # due to sandbox-exec.
    # The message "unable to load config" means that the execution will succeed
    # if the user has write permission.
    assert_match /unable to load config/, shell_output("#{bin}/confluent 2>&1", 1)

    assert_match /usage: confluent-hub/, shell_output("#{bin}/confluent-hub help")
  end
end
