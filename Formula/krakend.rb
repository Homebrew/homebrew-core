class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "http://www.krakend.io/"
  url "https://github.com/devopsfaith/krakend-ce/archive/0.4.2.tar.gz"
  sha256 "5243037a757fbdbb0bf1bbfd5ad8e018cf2aad6ece30e6f8a58c7c24f36b19b1"

  bottle do
    cellar :any_skip_relocation
    sha256 "71235262350e1906c25406f4e707f1c3bd9ecfe31b14b5af0ed785c8f274d9cf" => :high_sierra
    sha256 "74168eb0350f654bafd98d5919cf0c07434543af1f16aa3e7312865cce2e0900" => :sierra
    sha256 "b49037c17c6f80891ae9fa194424abbfbb92d031205df3cd103fd0f03f69bdbb" => :el_capitan
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
    assert_match "ERROR", shell_output("#{bin}/krakend check -c krakend_incomplete.json 2>&1")

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
