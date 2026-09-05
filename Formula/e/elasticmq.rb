class Elasticmq < Formula
  desc "In-memory message queue with an Amazon SQS-compatible interface"
  homepage "https://softwaremill.com/open-source/"
  url "https://github.com/softwaremill/elasticmq/releases/download/v1.7.1/elasticmq-server-all-1.7.1.jar"
  sha256 "a40dfd03fd8e2f17418f3c61a460c1daea902119145bdce97d09a81f03aa0428"
  license "Apache-2.0"

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
    ENV["ELASTICMQ_OPTS"] = "-Dconfig.file=#{testpath}/elasticmq.conf"

    (testpath/"elasticmq.conf").write <<~EOS
      include classpath("application.conf")

      node-address {
        protocol = http
        host = localhost
        port = #{port}
        context-path = ""
      }

      rest-sqs {
        enabled = true
        bind-port = #{port}
        bind-hostname = "127.0.0.1"
      }
    EOS

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
