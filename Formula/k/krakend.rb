class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakend/krakend-ce/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "9d9dcbd6e14cf474b0971f20fe76a0f37b0283e07e2a7b7a1beaaa9ab340a84b"
  license "Apache-2.0"
  head "https://github.com/krakend/krakend-ce.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93c2549b779919fd3b928cfac1213adbeca0c20ee6ea25a49257203ffecbcbec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34b813647679d06f06e597e7d017efc4e84c184cd1b2c809e7f49b14654bb6ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4888f468461c540fc60c9a23655e01d2d1edb1cc0fa955d6bd049de0339457bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "c79467bcb0cdc6e26a1226adb34fcd3325cb1c4740e7da03c3207f865bfca705"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "707379bda7798aa472e2a640d3726b42b87b4522dfe49347bd289ceb4c2c42b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8d544f18f1a2274369037d90b2ebdeff6c1eb56e5fc936ed0b4a71830c431f1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/krakendio/krakend-ce/v2/pkg.Version=#{version}
      -X github.com/luraproject/lura/v2/core.KrakendVersion=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/krakend-ce"
  end

  test do
    (testpath/"krakend_unsupported_version.json").write <<~JSON
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
    JSON
    assert_match "unsupported version",
      shell_output("#{bin}/krakend check -c krakend_unsupported_version.json 2>&1", 1)

    (testpath/"krakend_bad_file.json").write <<~JSON
      {
        "version": 3,
        "bad": file
      }
    JSON
    assert_match "ERROR",
      shell_output("#{bin}/krakend check -c krakend_bad_file.json 2>&1", 1)

    (testpath/"krakend.json").write <<~JSON
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
    JSON
    assert_match "Syntax OK",
      shell_output("#{bin}/krakend check -c krakend.json 2>&1")
  end
end
