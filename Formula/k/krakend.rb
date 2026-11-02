class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakend/krakend-ce/archive/refs/tags/v3.0.3.tar.gz"
  sha256 "ee444b0267929e56d4aa561bd7a442c90427550438c4b348e43f94ad37ec01ff"
  license "Apache-2.0"
  head "https://github.com/krakend/krakend-ce.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f2265a416a3143a92f50786caf18bf401c44e91ebd6e82e0865ab9b84abc1d00"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "99fd6f11cae7ade28dbfbcb38b049c06f2fbd4e71011c7290e34f85b09c2dd4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2f0ab722e295525468ed8d22663f3d458d3e9ebd137ffc9c6a3b3205f7256dae"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9d3097d7d18e327e6cf5798e2f8d9a1c5c41c61313ed14109b4d41e8f4d1faef"
    sha256 cellar: :any,                 x86_64_linux:      "9188b2c63a57acc913c69a6281c2628cb1c8c9518d13404ba756d75379807884"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/krakend/krakend-ce/v3/pkg.Version=#{version}
      -X github.com/luraproject/lura/v3/core.KrakendVersion=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/krakend-ce"
  end

  test do
    assert_match "KrakenD Version: #{version}", shell_output("#{bin}/krakend version 2>&1")

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
        "version": 4,
        "bad": file
      }
    JSON
    assert_match "ERROR",
      shell_output("#{bin}/krakend check -c krakend_bad_file.json 2>&1", 1)

    (testpath/"krakend.json").write <<~JSON
      {
        "version": 4,
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
