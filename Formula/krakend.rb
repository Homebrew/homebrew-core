class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/devopsfaith/krakend-ce/archive/v1.4.0.tar.gz"
  sha256 "1450c118e2d3ffbc651dc0632bfaafc6de60d9c0f7e273242c60cfb566d7c90f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cb7080b6b09aa600012f73d4d642f8d34abb303c654fb0f7be822c45d53e8c11"
    sha256 cellar: :any_skip_relocation, big_sur:       "da1c0cfbfbb7cec13f9c13f7f90e601895119a8a0a65088d468b5cc7205a6246"
    sha256 cellar: :any_skip_relocation, catalina:      "2f1510fbd313953f83dafd131fca4f51202b1b09c84b3befb9e78fa066300b69"
    sha256 cellar: :any_skip_relocation, mojave:        "923a0da6f38d1379b36a160eeadb6e6e1d96c40125592a5fb68fa7fa6ca3129e"
  end

  depends_on "go" => :build

  def install
    (buildpath/"src/github.com/devopsfaith/krakend-ce").install buildpath.children
    cd "src/github.com/devopsfaith/krakend-ce" do
      system "make", "build"
      bin.install "krakend"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"krakend_unsupported_version.json").write <<~EOS
      {
        "version": 1,
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
    assert_match "Unsupported version",
      shell_output("#{bin}/krakend check -c krakend_unsupported_version.json 2>&1", 1)

    (testpath/"krakend_bad_file.json").write <<~EOS
      {
        "version": 2,
        "bad": file
      }
    EOS
    assert_match "ERROR",
      shell_output("#{bin}/krakend check -c krakend_bad_file.json 2>&1", 1)

    (testpath/"krakend.json").write <<~EOS
      {
        "version": 2,
        "extra_config": {
          "github_com/devopsfaith/krakend-gologging": {
            "level": "WARNING",
            "prefix": "[KRAKEND]",
            "syslog": false,
            "stdout": true
          }
        },
        "endpoints": [
          {
            "endpoint": "/test",
            "method": "GET",
            "concurrent_calls": 1,
            "extra_config": {
              "github_com/devopsfaith/krakend-httpsecure": {
                "disable": true,
                "allowed_hosts": [],
                "ssl_proxy_headers": {}
              },
              "github.com/devopsfaith/krakend-ratelimit/juju/router": {
                "maxRate": 0,
                "clientMaxRate": 0
              }
            },
            "backend": [
              {
                "url_pattern": "/backend",
                "extra_config": {
                  "github.com/devopsfaith/krakend-oauth2-clientcredentials": {
                    "is_disabled": true,
                    "endpoint_params": {}
                  }
                },
                "encoding": "json",
                "sd": "dns",
                "host": [
                  "host1"
                ],
                "disable_host_sanitize": true
              }
            ]
          }
        ]
      }
    EOS
    assert_match "OK",
      shell_output("#{bin}/krakend check -c krakend.json 2>&1")
  end
end
