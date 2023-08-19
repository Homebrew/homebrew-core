class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakendio/krakend-ce/archive/refs/tags/v2.4.3.tar.gz"
  sha256 "71cd0094aa0b65aad4634ede3e8443839d279461342697855582c1712a5cb5b3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f177f258b90812573c13fb9abe7a6b79c5e421fa32328d2dc065b8715ae00fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7ec19f4bbc12779b2e22b6c252b5a9968d89958514ddc1394438330d2cbcf41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5bde8120cceddc6e5122ef71e8d7e030468aa0337cbfc46ec9e7915d817cd67b"
    sha256 cellar: :any_skip_relocation, ventura:        "aceaf8463c1e0227611cc7c8808459ac442c82b2cd1ce1fe16ee5dd514e48cc8"
    sha256 cellar: :any_skip_relocation, monterey:       "d5ff63f7988d26281046b049dd3eac01f3ca503a81a2158fc8e46dd88c7e9627"
    sha256 cellar: :any_skip_relocation, big_sur:        "60c389fb6fd8dceabb3d84107d126dbbd93e511915d9cc6bbf88136de93dd138"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70921de2c04c3bf0aa3690162a6f95e1a99bbfe268714f02695b113ad0542204"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "krakend"
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
