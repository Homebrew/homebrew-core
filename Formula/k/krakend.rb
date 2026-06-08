class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakend/krakend-ce/archive/refs/tags/v2.13.7.tar.gz"
  sha256 "e65f35561d863ffea5f28c9cad1e7dca8381806ea51d670066152e31a7ae6eb7"
  license "Apache-2.0"
  head "https://github.com/krakend/krakend-ce.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8bf4bc55d94c1b6ebe5bf609f0a939e6b3264b9d6afe95f110e424e5d701523c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf25c5641f15f51e1fc9e056c2293bfb06ae070d532b08615901f9637b0b5c1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "278603e14b11c5f2b08cfc44eddf43a74b27b51db255c338c5e5ba2f8ac4fdd1"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8b3d59d60b7fe5fe8ab493d2fd4495f037436e46f43c115a6b5b15b8b4117e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45b7d90e70c6f976fd83c506cba3d65c02cfbb9bab775982ca7a716c84b93488"
    sha256 cellar: :any,                 x86_64_linux:  "6f31f986fbd71a08ba8d0b37376af829a295c6ff9c64aefe006b55dd69914681"
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
