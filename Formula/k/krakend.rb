class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakend/krakend-ce/archive/refs/tags/v2.12.1.tar.gz"
  sha256 "316d65954b4db8b19b8878b5de0fd9424fd386f5c019f72051d9b201a7ba2393"
  license "Apache-2.0"
  head "https://github.com/krakend/krakend-ce.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ccc5978d495b6a32a1a9be6bf7dbd323c69f95f6884ce07cdf8caa77a7e8aaf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b3c63bbc1ee9714a4887f7ff0c1ee061542ff35b86df17309f61cd4e301e063"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7370e71795e91c7f012d2f3dbcd3f0218b3e38102b3b16e47cfac3091d5de822"
    sha256 cellar: :any_skip_relocation, sonoma:        "38450e79c36435fc16c1d9886f6807298184b150da125f922e98e3bf2b4746f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b3a62c97d4b4e6274e49d4e24a2adba18300116c7caf6bc351bcbebb84f0de9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42ce35e653cdeabc871676eb181b9639828764e78edd6c211589586f77fc2907"
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
