class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakendio/krakend-ce/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "64a65f17f46a92d09bfa9d76561887b515a8044c82e39becf700a9948317ca92"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6f39a7b7439e684933426aa2d896e0c72234f12d9722991d7517bef86c64fc5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5d34094883dd3dcff2b364d11278f32bda23a21e556a2fefabcb62fda52d427"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5be7a5b8403b0a7544eb1634e961861babed11a07667ceabb93710900b6c0e0d"
    sha256 cellar: :any_skip_relocation, ventura:        "6aff2a7d16434edca76cbf5ed18e25fc30776c3321e3f27ad4e027533dc28c4f"
    sha256 cellar: :any_skip_relocation, monterey:       "8e58dd57da2b4a3c8510a9b8aa7d561b7b6de119457e972fd0a2b92b58bba7ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "82c7e793339d35b26164c75a6a5e2035fdc465ee2264ec500cf24367d8df96d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ded5826b654691593bc5c7b2f5b093c6c87f6a9b472c592cd49c3d00ad864b39"
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
