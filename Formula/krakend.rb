class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakendio/krakend-ce/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "86647ef828d55d876f74e81d482d4c285d213a1a15f2deb2d2d61a7382dba74d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fecbc6dd3052cecf0edac06a69a3cbf308efd0a013424474306302e26b93617c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d484c85ec1c2b2d9e0c6de53830d9be21a7ed64fa4c068dc4ea4a5a06a2711f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d5dc57deb182fa10a3c142b2a408d81becdee508dd8e6fc2c85a09ef33a5293"
    sha256 cellar: :any_skip_relocation, monterey:       "e49dff76347d2d10ff6b322d9b0b49619b069a7f43d6d2e0f08e3cc6cff62d94"
    sha256 cellar: :any_skip_relocation, big_sur:        "43aedc7e24bcf028afe0beb4c03f97f97cbd7e09fb691d1e9e95cea50d2284a5"
    sha256 cellar: :any_skip_relocation, catalina:       "d043ab5b145575b5ba476e3f23baa36bd63bc331a0ba7735f568657467479417"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d89f40f572e946063fd3243456f53c0e513f7e7491f9b62c720217f8f319ca89"
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
