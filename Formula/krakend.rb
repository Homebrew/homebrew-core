class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/devopsfaith/krakend-ce/archive/v2.0.4.tar.gz"
  sha256 "d85210b10045aec53cc568aa29ff015848d777fba770335a0f73a629a0f3e9ae"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "447e030b8bc5f80d7f1ae1839fd3c8ce219113807e8f74ece3fdf16ede03f196"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f6171e11c718317373f6ccbb8d71c236e5826fb904c947fae6f4cb541b3654e"
    sha256 cellar: :any_skip_relocation, monterey:       "356cdb59bdfe01ca84270cf9d2e46a94e4b0ae9756d769ae849b1df69d975279"
    sha256 cellar: :any_skip_relocation, big_sur:        "e10b295fcd2d4cdd195a151d0695c956e2e8f8a1e9d96b2d0153d46f46387279"
    sha256 cellar: :any_skip_relocation, catalina:       "0fa29e98b49d179d567503c0ac59fa5a13fa12e6f2c025bef55c8cdbf6e95431"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1076ba1934b2b0ea16527bf89a727d8fde4d51f15b06781f5fe91da6975ab6a3"
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
