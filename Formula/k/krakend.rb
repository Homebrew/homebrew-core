class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakendio/krakend-ce/archive/refs/tags/v2.9.3.tar.gz"
  sha256 "ab1b6bbf603c37751da320f9391afd25cef8570176debc6c760a0852c2dcc473"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f41c6ce07bdc9abcbd0c09e7eb3732fc757d67875a1d8b20df4d81d5662254d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ea5659032140b3d22913d22099a272840c88234d766eaac7078a4c6c320de3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9ccd6035434e8981b5d85153df4570723a9149e03847ac846f1941cf7bd8101b"
    sha256 cellar: :any_skip_relocation, sonoma:        "77baad9a9395bfcbd3b7e328025c4720a0be27eaa721b1c270f0bc7e929b589f"
    sha256 cellar: :any_skip_relocation, ventura:       "52994f4bf4fa2bd996a58d6e5f1debc20bcfa41297bf4c57d0085fccbc9db0cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "447e187083cb3be7e7a82a3e93887376749b0238db90e25a12311d7dd11aadd1"
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
