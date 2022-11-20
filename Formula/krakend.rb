class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakendio/krakend-ce/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "ae1f7c5b83f77744db2f860555feff93998c52f8e5986cbe9eeefc8e18595290"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5eebc41b5f9f7150704d7078f8438ce58d250493e316c90cd76fed295cb99a70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f62971146ee9f0f2a3ff9067d17914c2bb08deabc03b3f215189d75378f87064"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b660f57fe4eb4823510fecb55b2ab1dad7d660f80c538e37183845b0ec21c10"
    sha256 cellar: :any_skip_relocation, ventura:        "b71850722965c822d56819ebd82b9a72945727f6a148b12ac2095a371ca64a3e"
    sha256 cellar: :any_skip_relocation, monterey:       "04e3b0df464ad15e684502d79ab907eac57e107e42f6d09507c0028717033654"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b97d035d8b455883b0584f67e2538be87d36e9c7dc3785093aad69819d6480c"
    sha256 cellar: :any_skip_relocation, catalina:       "a8e8549baf50408c1b52857d78827a226ce76c0a85b8b1fd65035f48b57824ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "958cce08b8287a5951dff0c8c9b26c33fbcdc8ba26e14049f5d4451781e47402"
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
