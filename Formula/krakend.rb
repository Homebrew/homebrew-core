class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakendio/krakend-ce/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "ae1f7c5b83f77744db2f860555feff93998c52f8e5986cbe9eeefc8e18595290"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "771f9ef57b5e2c93239adf93b685a80bf607df084298a11b479c5ccc1b236afe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2f634ca4da55c7e9457edc904deeeb03999c7debcfdbb2d9f7a51ee6691bb37"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd5a6b0227658cda757808674e7bc1e7156f4d80db449b860c15350305c61360"
    sha256 cellar: :any_skip_relocation, monterey:       "e3bb56a1ced8dfeca0d70d081c09e9b519b552e65387861a7cf8e95244111a11"
    sha256 cellar: :any_skip_relocation, big_sur:        "e26a59573f9006254920a89440d4d76cf7ff6a483060097b55f95694b45ad51d"
    sha256 cellar: :any_skip_relocation, catalina:       "43d270e23dfe0700768977097f9f0eb2984328c6ec52643f774f0895dcebecb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c935354292f8f1442ed12883760f85c3221f5b645a1249c1fe201c1e3344a636"
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
