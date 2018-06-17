class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "http://www.krakend.io/"
  url "https://github.com/devopsfaith/krakend-ce/archive/0.5.1.tar.gz"
  sha256 "5c9196163d430a2527636a8aa77056b8dd870beb73091e791eaa88bd61960bf7"

  bottle do
    cellar :any_skip_relocation
    sha256 "687f59fe313775eb1b946fd5cbc193ee86d9118282d29e87c86ee0f811e9a8bf" => :high_sierra
    sha256 "64eea62b639fdf136e16b18d48d0425d6897c1e8f347c1a41ef4a4ee5aab2bf2" => :sierra
    sha256 "806936529d0c4b29a56a2c778566c34068ebbe5d559844185883faf37e6b3be4" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/devopsfaith/krakend-ce").install buildpath.children
    cd "src/github.com/devopsfaith/krakend-ce" do
      system "make", "deps"
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
    assert_match "Unsupported version", shell_output("#{bin}/krakend check -c krakend_unsupported_version.json 2>&1")

    (testpath/"krakend_bad_file.json").write <<~EOS
      {
        "version": 2,
        "bad": file
      }
    EOS
    assert_match "ERROR", shell_output("#{bin}/krakend check -c krakend_bad_file.json 2>&1")

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
    assert_match "OK", shell_output("#{bin}/krakend check -c krakend.json 2>&1")
  end
end
