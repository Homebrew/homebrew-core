class DjlServing < Formula
  desc "This module contains an universal model serving implementation"
  homepage "https://github.com/deepjavalibrary/djl-serving"
  url "https://publish.djl.ai/djl-serving/serving-0.40.0.tar"
  sha256 "30463317ae3a012572101a1feb1b7ab4af341434e43a99a092552673936eaa52"
  license "Apache-2.0"

  # DJL Serving releases independently of the main DJL project.
  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "663207993e5b39f09acefa66bae508527ab8546e75b75d52bd4cdf9873776f69"
    sha256 cellar: :any_skip_relocation, all: "56d09133de25da28047f2f8c5fe26b6ce8994b3c15a2b27d3758bccc4c4d419a"
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
