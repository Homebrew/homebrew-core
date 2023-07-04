class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakendio/krakend-ce/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "2c53f702062d244a6922257cfb9572025f9824b1da108acf68bc06594c6c8228"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "330000950387fadd10abad8bd89842341d94cdaaa9b300b2a6acd14313149d56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10d9e6486b939b3a75cb67d74e39cf07ff75e34f2e7398960f81f6649a9db96f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5149a6302dc02750886173e301543a1d5ba3cbc56df7b0715d82e69c3c83985e"
    sha256 cellar: :any_skip_relocation, ventura:        "ed6ee2d3fd2e6744a0da23da21a7207e2a5d63cf26c25b022f9175272dc1af14"
    sha256 cellar: :any_skip_relocation, monterey:       "0dab1e5769835994014263518de2599852cba20c6f17d396bbca69a39ef0d915"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c890b4dc0a8b39641a2f4f79d9082deb47b038719efcf6c08f56463f371110e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a03bfab0ceb8c51684f7cde777e06656cb704b51e5b2f7cdbce867b8aefbac37"
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
