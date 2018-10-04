class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "http://www.krakend.io/"
  url "https://github.com/devopsfaith/krakend-ce/archive/0.6.1.tar.gz"
  sha256 "f6dd5d8dbb5a3be488516ea5c0b3b234c80a330f7981891f64aaddd356302b2d"

  bottle do
    cellar :any_skip_relocation
    sha256 "d7d11d8fafa707eae16114bc45307564b56f0a02d8ad2250453c6c5c8eafe152" => :mojave
    sha256 "67670fe74911c949c00b7addedc9dee7057c40c8a5c2f8df6b109fe42cb9d2a8" => :high_sierra
    sha256 "e4d5429a9f05738fd7531454c8c922652d48bf63c922b32b4c8ca778d6996d30" => :sierra
    sha256 "77b1d557cc01bf9408d98fc2508570c8a6638389bb46ec5ca9a82e343fa5a955" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go@1.10" => :build

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
