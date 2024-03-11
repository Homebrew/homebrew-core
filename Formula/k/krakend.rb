class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakendio/krakend-ce/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "a7d767cbe5a94fe26867aa91b9b2bbebe557b470be9c72f286eaeb2134d4de48"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4febdd1f82558b141cb3f256f9db3d09d223aabda03055639b75b4a902b5b641"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "add9b693acf1ebf66b33856d2445b763d207de624b61bcb376bb2e08d7f8601e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ff20d5c5fbcb91d8b7024dca56e0638b6ec57a27907bf73d2562fd1a2d0b6bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "57402cba3d5a8b7aeaba3eb0886e02c822146e178015dc6f03343714b77e068a"
    sha256 cellar: :any_skip_relocation, ventura:        "7b99578c0188d4b0b94fbc960fcfb33a5130c3c3002dbf902c8790980803783b"
    sha256 cellar: :any_skip_relocation, monterey:       "0b6f7d6b850a5524799c8920b6426eadf4673010251fd0a55f5a14f880e856fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab456399034ba81b34c4e64a87ccbc3f0a3b256eedfb3a1d453edc83e1c47aaf"
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
