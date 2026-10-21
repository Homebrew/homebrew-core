class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakend/krakend-ce/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "ce423d762a2e2b514bcbde114036cca287d65f50ab1148953b33e3fb0bbf91b3"
  license "Apache-2.0"
  head "https://github.com/krakend/krakend-ce.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f9f2da53b91cd78d3605814f8069f4d7b4394fca616b5c12f5d8095cfca09492"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "05d9fb8d5a8bf9f9ecaedf35cd0b7a3f1bec75252fa190e814977abac9021541"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4a103e7bd8a0e440ba0022af3538d852ed2998dc1c5ef330f6d2ffffed3ce8af"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c6b3d1d3c8899bfd9a844e21640d8e7a80c22146396a9fb6bed96af366496f6f"
    sha256 cellar: :any,                 x86_64_linux:      "acf52129e648d5b78642c68c269a7ab06dc92959c5f9eaa8b64e06f00d8f1740"
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
