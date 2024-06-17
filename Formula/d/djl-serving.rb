class DjlServing < Formula
  desc "This module contains an universal model serving implementation"
  homepage "https://github.com/deepjavalibrary/djl-serving"
  url "https://publish.djl.ai/djl-serving/serving-0.28.0.tar"
  sha256 "2f78ca2d513c0617e434662458ae1777959c046b66a4919587f81c2c4ca2efc1"
  license "Apache-2.0"

  # `djl-serving` versions aren't considered released until a corresponding
  # release is created in the main `deepjavalibrary/djl` repository.
  livecheck do
    url "https://github.com/deepjavalibrary/djl"
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc6d7966eddbcdf5a93395bf6d0344bef3963cef4e1af33607147ce32a63431e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "315fac4c81a96d501208411761486461cf186f433253e49f39e5fc66adc5d7a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fecd7abc662195d4fe91b6807562188fa10851f4a58ea7ebf1a463ffbf0bbe4d"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c7b9da07a5df47c1a1c74fae3a10b289058b7ee1e4863d7825f3ffff82159d3"
    sha256 cellar: :any_skip_relocation, ventura:        "7a5e32262e99bf918f7b8fc92c417df3df324f92b38ff90d2e135297a6197a72"
    sha256 cellar: :any_skip_relocation, monterey:       "9653e8c392845ff6667e6b543e9d6ba46f9b0f93809ba806044ac1eee70e8926"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e01f6ddf13b2f804e018f589724948e9c12de58e556b5f30191c02c188abcdf"
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
    assert_match "{}\n", shell_output("curl --fail #{cmd}")
  end
end
