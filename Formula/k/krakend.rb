class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakendio/krakend-ce/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "a7d767cbe5a94fe26867aa91b9b2bbebe557b470be9c72f286eaeb2134d4de48"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "73a36ca734cb033d9402e0a168ec29d67edc632670be4b5e63e28d9b30ef7bbb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dcb21a4dee7e27599f856264d7e0c1f407c6aeb77e21697f12c3dd899cadd9c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74f09c9db7cbd9bbe3e2c30a765b20795ee35be1f42d0cc711a83693dceee0f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "a40c5ce2cb24f40558d0e78b9eb552a1e72966aa58356f61da2bab9de97c67c7"
    sha256 cellar: :any_skip_relocation, ventura:        "a7eb6d95cc66523f6fe0877897bbd1852cf9b6bbc70f2f11df237fe9ce3e86a4"
    sha256 cellar: :any_skip_relocation, monterey:       "225a1c86dcdbf829f800929b3a15d0f36267ffa4dcc4d3d37cbf4ab35c82ec66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12c461668b00b0635f2a5f6ab14bcd2315f44a2fe8b6a1ff070f95318693b5eb"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "krakend"
  end

  test do
    (testpath/"krakend_unsupported_version.json").write <<~EOS
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
    EOS
    assert_match "unsupported version",
      shell_output("#{bin}/krakend check -c krakend_unsupported_version.json 2>&1", 1)

    (testpath/"krakend_bad_file.json").write <<~EOS
      {
        "version": 3,
        "bad": file
      }
    EOS
    assert_match "ERROR",
      shell_output("#{bin}/krakend check -c krakend_bad_file.json 2>&1", 1)

    (testpath/"krakend.json").write <<~EOS
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
    EOS
    assert_match "Syntax OK",
      shell_output("#{bin}/krakend check -c krakend.json 2>&1")
  end
end
