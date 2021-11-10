class DjlServing < Formula
  desc "This module contains an universal model serving implementation"
  homepage "https://github.com/deepjavalibrary/djl-serving"
  url "https://publish.djl.ai/djl-serving/serving-0.14.0.tar"
  sha256 "9215201c92273e9843a6ecc0b086d8032bb598220bcb06d5f07ff7bfb90df6f1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c438d15069721e4a5c1d1c34155da406217c14cb06a24f36c1766594b4ca693d"
    sha256 cellar: :any_skip_relocation, big_sur:       "c438d15069721e4a5c1d1c34155da406217c14cb06a24f36c1766594b4ca693d"
    sha256 cellar: :any_skip_relocation, catalina:      "c438d15069721e4a5c1d1c34155da406217c14cb06a24f36c1766594b4ca693d"
    sha256 cellar: :any_skip_relocation, mojave:        "c438d15069721e4a5c1d1c34155da406217c14cb06a24f36c1766594b4ca693d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "399edae507bdaee85fea94f67238a99faab7d666ebe220781991903385cc288e"
    sha256 cellar: :any_skip_relocation, all:           "c211b2d0f905a4adcc073cb04c9b72fff408474b0422244d26b2a32112169f3b"
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
