class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakend/krakend-ce/archive/refs/tags/v3.0.6.tar.gz"
  sha256 "3e32c172026c54a0c8bd2bb544ba1183dd57f4ec89f735e23ebb0919cb5619d8"
  license "Apache-2.0"
  head "https://github.com/krakend/krakend-ce.git", branch: "master"

  bottle do
    manifest_sha256 "3fe9a7238908a441e6b364e81f9813c4f6a8e1d4d6b1aff57907f3ded1389996"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e7216896ad36ad6b5c48eb26819382cb102784d93c931abb50ef211de179f112"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "110b786bb447807fe94abf81809179efe68dd98ad7ef2db1f97059099032772d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "73acb167d11f55c4609d71866ed0ba8f4d83767f6da17ae12ebebc58a35128ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "68df7d03df3390a612b6af021105d438104c00ecd5fa0e3a7541c56cde30dc9f"
    sha256 cellar: :any,                 x86_64_linux:      "b0f9bebcfb0dfd96f86a0db44156b37d033cfdf5f8a316888771b1dc4a8cb2ef"
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
