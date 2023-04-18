class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakendio/krakend-ce/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "64a65f17f46a92d09bfa9d76561887b515a8044c82e39becf700a9948317ca92"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "021ca55192df22903341e5faf2d1181de67eb8f4ded1e0032551b22d2634563d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "135af3ec9b828e06a67d79f85be210845cd7ca866ea9b66679bdb85d1feea007"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18f327983128e891f2545aebb4619c55410e98150bf10df0097800432a401a0e"
    sha256 cellar: :any_skip_relocation, ventura:        "b1e1108e881dc716c6381f6d28bebde1a5c9da4ff43ba6f4266652db5a57ca2a"
    sha256 cellar: :any_skip_relocation, monterey:       "9bce8ccad86a4e3bdd9b05313f597fac19febe47f8cb973789bfee2aec95d7ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "22953f3d9c0d7603a3ce9b49126ec6acdd2133755cc8375c7a2c604fa1bcfdfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8efa9e81fc38fda0863c7c5950d9eebd7a0c898f9706f40a4e36400e290adf72"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "krakend"
  end

  test do
    (testpath/"krakend_unsupported_version.json").write <<~EOS
      {
        "version": 2,
        "extra_config": {
          "github_com/devopsfaith/krakend-gologging": {
            "level": "WARNING",
            "prefix": "[KRAKEND]",
            "syslog": false,
            "stdout": true
          }
        }
      }
    EOS
    assert_match "unsupported version",
      shell_output("#{bin}/krakend check -c krakend_unsupported_version.json 2>&1", 1)

    (testpath/"krakend_bad_file.json").write <<~EOS
      {
        "version": 3,
        "bad": file
      }
    EOS
    assert_match "ERROR",
      shell_output("#{bin}/krakend check -c krakend_bad_file.json 2>&1", 1)

    (testpath/"krakend.json").write <<~EOS
      {
        "version": 3,
        "extra_config": {
          "telemetry/logging": {
            "level": "WARNING",
            "prefix": "[KRAKEND]",
            "syslog": false,
            "stdout": true
          }
        },
        "endpoints": [
          {
            "endpoint": "/test",
            "backend": [
              {
                "url_pattern": "/backend",
                "host": [
                  "http://some-host"
                ]
              }
            ]
          }
        ]
      }
    EOS
    assert_match "Syntax OK",
      shell_output("#{bin}/krakend check -c krakend.json 2>&1")
  end
end
