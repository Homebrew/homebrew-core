class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakend/krakend-ce/archive/refs/tags/v2.13.11.tar.gz"
  sha256 "eb69e9f515922d705d865ee75ee3cc9ea0d5787f6f5062c15b77ccb9bb702215"
  license "Apache-2.0"
  head "https://github.com/krakend/krakend-ce.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8859d9ef3dc75b81bfc431c66fc24e020aa79947a9765876b146c72e9a1f59b1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "51c5f038247b82e19f96ad4e84fc9427c8631a6d8688cb7e40cac5a5cab956b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "182537bc9b261724cb27bbc5bf3f9d82f8c1fa4b649e91eb789f4e169b6434b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "c95be0ed743b839f80551e188fbb0634415d9142b6f8bb4c0c4d6d1d722ec044"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f5ef98d914b192732d115163da4fdd0835785716ea79bf8c2e32749e44e8570d"
    sha256 cellar: :any,                 x86_64_linux:      "456c35837263edc4f40ef1a98889dc0a7643e93a38928d249947cbf75f5d0aec"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
