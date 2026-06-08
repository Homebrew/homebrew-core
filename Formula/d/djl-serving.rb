class DjlServing < Formula
  desc "This module contains an universal model serving implementation"
  homepage "https://github.com/deepjavalibrary/djl-serving"
  url "https://publish.djl.ai/djl-serving/serving-0.36.0.tar"
  sha256 "f91e90522f38a8c86172c34620d88202e7222233804a240f05d10c51b72085c0"
  license "Apache-2.0"

  # `djl-serving` versions aren't considered released until a corresponding
  # release is created in the main `deepjavalibrary/djl` repository.
  livecheck do
    url "https://docs.djl.ai/versions.json"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :json do |json, regex|
      json.map { |item| item["version"]&.[](regex, 1) }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a85ddef0f4af5264220c18c66092e069826eb427248dd5821dae801499e54edb"
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
    spawn bin/"djl-serving -f config.properties"
    sleep 30
    cmd = "http://127.0.0.1:#{port}/ping"
    assert_match "{}\n", shell_output("curl --fail #{cmd}")
  end
end
