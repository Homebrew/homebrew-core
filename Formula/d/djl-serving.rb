class DjlServing < Formula
  desc "This module contains an universal model serving implementation"
  homepage "https://github.com/deepjavalibrary/djl-serving"
  url "https://publish.djl.ai/djl-serving/serving-0.29.0.tar"
  sha256 "69b77dbb50e8c672e7a6bd477aeb0e47a0b5f9d66983563e93cb9742bb8c5f08"
  license "Apache-2.0"

  # `djl-serving` versions aren't considered released until a corresponding
  # release is created in the main `deepjavalibrary/djl` repository.
  livecheck do
    url "https://github.com/deepjavalibrary/djl"
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "766701b17c16290592067f32366742f212902faac116aa1f1230c8ff2f3b81a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "766701b17c16290592067f32366742f212902faac116aa1f1230c8ff2f3b81a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "766701b17c16290592067f32366742f212902faac116aa1f1230c8ff2f3b81a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "766701b17c16290592067f32366742f212902faac116aa1f1230c8ff2f3b81a8"
    sha256 cellar: :any_skip_relocation, ventura:        "766701b17c16290592067f32366742f212902faac116aa1f1230c8ff2f3b81a8"
    sha256 cellar: :any_skip_relocation, monterey:       "766701b17c16290592067f32366742f212902faac116aa1f1230c8ff2f3b81a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06c0535de1e8451be38bd6098c8c2f353a3791859e5f4749ca374f14497a3d79"
  end

  depends_on "openjdk"

  def install
    # Install files
    rm_r(Dir["bin/*.bat"])
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
    assert_match "{}\n", shell_output("curl --fail #{cmd}")
  end
end
