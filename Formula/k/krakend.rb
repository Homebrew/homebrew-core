class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakend/krakend-ce/archive/refs/tags/v3.0.3.tar.gz"
  sha256 "ee444b0267929e56d4aa561bd7a442c90427550438c4b348e43f94ad37ec01ff"
  license "Apache-2.0"
  head "https://github.com/krakend/krakend-ce.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b1c9703b189ac2cb88e50a277be670a23860c6f7685cc5c0829c6a19d915d7a9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "98eda82e6e1000eada6dedaeee99c5588964b3ac5374a82cdc5589a6be915f32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6a658dae1df069df2a62a2b0fa99874beb609e4914943c18dc130f8d2a069b16"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "87ac8dc448a7389261a489d1644b480bc332131499a3a6d8f95b33ea09f01b64"
    sha256 cellar: :any,                 x86_64_linux:      "79f81a24eef390e1e5d943af3e8de34f155834d6a217d3c722fe4dd2e1eec029"
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
