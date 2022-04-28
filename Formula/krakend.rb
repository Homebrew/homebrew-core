class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/devopsfaith/krakend-ce/archive/v2.0.3.tar.gz"
  sha256 "17bebd9d500434184f09e22ddf00bf6d688e9277b0836d3795fe42bdb7db7919"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c9c858f337ac130da385208c89ae9d80a60cd7853b86c1d69f90acfc9d12569"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81005b3b02c719998e4415ef13afe5c485579c6da02ca8da5ff6b9bd9554c890"
    sha256 cellar: :any_skip_relocation, monterey:       "f06b8c7e4e57918f1198e6d8e5feede80a2961c2ff1b8cc360f64847a3239e7a"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8d31808681ed7d23c404dca46b8d56fa374c6ebda39956b0718cb8a7e0e1c24"
    sha256 cellar: :any_skip_relocation, catalina:       "70695c7b5adf22d2bd89612a60a822a8fd71f9d28a09006c220f49ee13e3130c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95429d776564613625750f0e69883364f2ec67d89764b89c67c18b163c80cb0e"
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
