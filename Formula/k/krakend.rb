class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakendio/krakend-ce/archive/refs/tags/v2.4.6.tar.gz"
  sha256 "6ed9c8f146e341b4de7d5b4492acf0d1b35fdc9f1c1eef766ca02be898919239"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2f31544598a528d9c25da85284ada1722c125b7f3a4c2f9687b982b9f97b2ab3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "add71cb877826255a39fda3857a29929cd62e0d0ec1e115b7ffca64c2a6178d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27dbaa3c6524b750b3faa768ca2d1637f9860ae0280c09a31d4deb7ce313a16e"
    sha256 cellar: :any_skip_relocation, sonoma:         "505dfcab4ad08ed2ea77e77838e30755053c4088c3a1506231eed5b4e82e0fb1"
    sha256 cellar: :any_skip_relocation, ventura:        "f815dddb0d088ad2ee3ec59730b936c0b6547d963ebea922545c2de43b98bfb9"
    sha256 cellar: :any_skip_relocation, monterey:       "55ac111a64729ede8e299eb953154090fc043e17f64f688376654e1abe908e50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "751f50d3d3efd9ee53a94bf720b2ea43dfaa4c23e3317d2d3c8e78f46ca574b9"
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
