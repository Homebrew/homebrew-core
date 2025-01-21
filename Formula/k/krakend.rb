class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakendio/krakend-ce/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "beb1e9bb3e89a9b20e5fe91d759f4e8788ae0ea7524c8145f9b0c56570b9cc8c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5870e64a10ebe55480859a9143c4135a237b5235a0fd3e22c548717d5032a4c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4005b4ab66cf91cfd8f9f84e54af2a8bb535b2c202ee98b633c414103895b0b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dc1d77c442f7c147e01a52b6e8458975ee5347006ad67a64b750edd5efea8e95"
    sha256 cellar: :any_skip_relocation, sonoma:        "378aee36f77f6086d08faa20ba9edbf43642db2f5e1ec652533b9800fcc48409"
    sha256 cellar: :any_skip_relocation, ventura:       "00b1e65e5b6d5a7334f896fe949d7f5642e5c63dbaf5e32c286331f931d955ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "067808db87345b1fb5c9cba4c4f64ed910c1b22da543484500265ff65a6c16a7"
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
