class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakendio/krakend-ce/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "8f26361895660e27d065ca9ea0a26c171621b3aa7bad553b1ac597da90446064"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7304bf1f96cac693df6354a626cb52a2d59ed384a36d26497fbdcbdcca856a86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd8f13a4124243fee4d769f1353b15c190a8de0b2c1e81c75e348ef1400da99e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e571343c395958f5d213010cb795c18125512ea242a097401541c4a501cae9a"
    sha256 cellar: :any_skip_relocation, ventura:        "f7cbdbaf965a75270a47a943fb5a3e2771e02903924d42996a36b5772ce12a71"
    sha256 cellar: :any_skip_relocation, monterey:       "6997ac6e05f29ba576ff5351b717cea38fe189fd15e16e28500189447ce33308"
    sha256 cellar: :any_skip_relocation, big_sur:        "83541f261950a06c3cf9c80b7dc4c6571b4f1a1d7f7786edab9a3683a37d6daa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b508d4ffd497ec9585d977454a75f8c0e9d5a0ac350cfad79347f541590f260b"
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
