class Elasticmq < Formula
  desc "In-memory message queue with an Amazon SQS-compatible interface"
  homepage "https://softwaremill.com/open-source/"
  url "https://github.com/softwaremill/elasticmq/releases/download/v1.7.1/elasticmq-server-all-1.7.1.jar"
  sha256 "a40dfd03fd8e2f17418f3c61a460c1daea902119145bdce97d09a81f03aa0428"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1349e260f8076539c1a65d055ff5267a21fe023a2ff712b909970e08e6cd0a07"
  end

  depends_on "openjdk"

  def install
    libexec.install "elasticmq-server-all-#{version}.jar" => "elasticmq-server.jar"

    bin.write_jar_script libexec/"elasticmq-server.jar", "elasticmq", "$ELASTICMQ_OPTS"
  end

  service do
    run opt_bin/"elasticmq"
    keep_alive true
    working_dir var
    log_path var/"log/elasticmq.log"
    error_log_path var/"log/elasticmq.log"
  end

  test do
    port = free_port
    ENV["ELASTICMQ_OPTS"] = "-Dnode-address.port=#{port} " \
                            "-Drest-sqs.bind-port=#{port} " \
                            "-Drest-sqs.bind-hostname=127.0.0.1"

    pid = spawn bin/"elasticmq"

    begin
      url = "http://127.0.0.1:#{port}/?Action=ListQueues&Version=2012-11-05"
      output = shell_output("curl --silent --fail --retry 5 --retry-connrefused --retry-delay 1 '#{url}'")

      assert_match "ListQueues", output
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
