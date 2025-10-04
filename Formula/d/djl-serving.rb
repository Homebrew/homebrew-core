class DjlServing < Formula
  desc "This module contains an universal model serving implementation"
  homepage "https://github.com/deepjavalibrary/djl-serving"
  url "https://publish.djl.ai/djl-serving/serving-0.34.0.tar"
  sha256 "adabd4af596b278ecf890074825b480a11983751a8eaa9e1e22c94d93a18982a"
  license "Apache-2.0"

  # `djl-serving` versions aren't considered released until a corresponding
  # release is created in the main `deepjavalibrary/djl` repository.
  livecheck do
    url "https://github.com/deepjavalibrary/djl"
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a9fc595bce39f3c224d4b3e20ff06fbb3ca8e0a0706a6b2cacb2c95db088d673"
  end

  depends_on "openjdk"

  def install
    # Install files
    rm_r(Dir["bin/*.bat"])
    mv "bin/serving", "bin/djl-serving"
    libexec.install Dir["*"]
    env = { MODEL_SERVER_HOME: "${MODEL_SERVER_HOME:-#{var}/djl-serving}" }
    env.merge!(Language::Java.overridable_java_home_env)
    (bin/"djl-serving").write_env_script "#{libexec}/bin/djl-serving", env
  end

  service do
    run [opt_bin/"djl-serving", "run"]
    working_dir var/"djl-serving"
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
    assert_match "{}\n", shell_output("curl --fail #{cmd}")
  end
end
