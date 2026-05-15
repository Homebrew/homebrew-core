class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakend/krakend-ce/archive/refs/tags/v2.13.5.tar.gz"
  sha256 "81afd8bafb732d95a635df22600088a93fc4318baceed5058dd0923d729b72fa"
  license "Apache-2.0"
  head "https://github.com/krakend/krakend-ce.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af4743c2dacd672028bc035b4357d13679f455fecf625c00ba7dc17fa39d226b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef3153a98a9d4fceb25e83d6e057c96f0263df9a8bf6fc0cafbdb4076b65e28a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "396e424f3066711b41dc2f4fb0557a27485b2f5f10cf24e40a8dbd15b42622d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f41c9e7f5a5bafcc6f42a655eb550897d9cc6dfa64309eda1f7928ac0924d1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "571d7260df04e048e8f4cb703a3b8b1cabe51f2d2cd82bfadd6e4471ba889dd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6992ce9f8432116ea6771390251174400352a9b5f58386f6de756464fd536b74"
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
