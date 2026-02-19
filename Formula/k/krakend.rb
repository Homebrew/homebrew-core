class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakend/krakend-ce/archive/refs/tags/v2.13.1.tar.gz"
  sha256 "b6ddc4dc7c27c0f6a4aa582078c923c5d161c43cadbd2bb9e01bd3b856bdfc6b"
  license "Apache-2.0"
  head "https://github.com/krakend/krakend-ce.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a4a26f20452b4ebb78655b9a3b3ac896cd481a164d26f9cc02961046f9d2892"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1136cb5a8509d4bf075114a802e1ca0b1b33b36c5040c3240d96829db936abc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3adc0b503245a1fc59df1be403b16dba2229da9516488065eede64540bece3dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8f3091e5818ab546a74c8800b8b206ec72450050b5b13fe82bfca104d48809d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "447b6275821053e1ae16b16dfab59f5ed8fb360544debc8020df6763d4e7acc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b8eec58a748fe36b27143cf991e08a4d29a5e0073f61f8ba302d1b5b873919d"
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
