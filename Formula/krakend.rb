class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakendio/krakend-ce/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "30bfafb835a8e0fef6fc04a9aaf529cc9cf9b7ba33c03cf0affe8897222c816a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b140ae01b6b65668216ccf4b5182cd8815d300b20adc3c1188b98a14446bfd9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a424b225d493bee87f1da8413ced27b841472b421b14c4074c7ad1a5a438829"
    sha256 cellar: :any_skip_relocation, monterey:       "945cdb76964b18402e8c2d74e910bfafeee15d64339a81c33ce28ee5e559447e"
    sha256 cellar: :any_skip_relocation, big_sur:        "afc860086982c8427d425ff10494a759b900900e0f0b947e425e85e279662d0a"
    sha256 cellar: :any_skip_relocation, catalina:       "9fd87244eb454eabcdeba3beb3bc42a404024a0c3a92a287fba8ddbf2e57d804"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a5652447b3076134516e632b0285d47ccde12af34b8ba3a004e8757b126b740"
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
