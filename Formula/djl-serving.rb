class DjlServing < Formula
  desc "This module contains an universal model serving implementation"
  homepage "https://github.com/awslabs/djl/tree/master/serving"
  url "https://djl-ai.s3.amazonaws.com/publish/djl-serving/serving-0.12.0.tar"
  sha256 "b715a7a83c1116813840a01aabe95dc1bcb83f3888420bb7de8f88d580d7bd0a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2247e58049d51afb16ef9f2469c97c885cc33fefad6f95c5c382909b2aaf2a8b"
  end

  depends_on "openjdk"

  def install
    # Install files
    rm_rf Dir["bin/*.bat"]
    mv "bin/serving", "bin/djl-serving"
    libexec.install Dir["*"]
    env = { MODEL_SERVER_HOME: "${MODEL_SERVER_HOME:-#{var}}" }
    env.merge!(Language::Java.overridable_java_home_env)
    (bin/"djl-serving").write_env_script "#{libexec}/bin/djl-serving", env
  end

  service do
    run [opt_bin/"djl-serving", "run"]
    keep_alive true
  end

  test do
    port = free_port
    (testpath/"config.properties").write <<~EOS
      inference_address=http://127.0.0.1:#{port}
      management_address=http://127.0.0.1:#{port}
    EOS
    ENV["MODEL_SERVER_HOME"] = testpath
    cp_r Dir["#{libexec}/*"], testpath
    fork do
      exec bin/"djl-serving -f config.properties"
    end
    sleep 30
    cmd = "http://127.0.0.1:#{port}/ping"
    assert_match "{\n  \"status\": \"Healthy\"\n}\n", shell_output("curl #{cmd}")
  end
end
