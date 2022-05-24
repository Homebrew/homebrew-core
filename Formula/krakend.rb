class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/devopsfaith/krakend-ce/archive/v2.0.4.tar.gz"
  sha256 "d85210b10045aec53cc568aa29ff015848d777fba770335a0f73a629a0f3e9ae"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82b2eb134dd785cd3843a375da1e4454ca9f9ad37973ddbb52ba42b53ce5061b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c1fe88d72bdf0eb72b318a6e6c0c9ab8813a36a3c257c447257434a175cdde58"
    sha256 cellar: :any_skip_relocation, monterey:       "7c325174fa368cf6fe66e463c68b2a9b430976bddcbca46d33cadeb03cbd15e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c488c3f72d5e4be8a026ad04910f19722b7067e51a86928f15760eacea25630"
    sha256 cellar: :any_skip_relocation, catalina:       "d6f0f4582886fde01212dd764051004c44919aaabcbf500b43e1dc5993e0f57a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ba1c2614eb9c1288babf21893d99092376c7ff1be4920172391fdd6fa85ea74"
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
