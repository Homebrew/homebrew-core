class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakendio/krakend-ce/archive/refs/tags/v2.6.3.tar.gz"
  sha256 "1eb317358c49244267daf4c1705f67c7b11c657a0edd75ae31fcef84190ab545"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b865c827c027a3f9a40766b0d15410dd6639a7aa07699e321fce655c3fb605bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d814907319d44fd327838e80c2ec0ca5c28eeac81096064b3b3ef50819f4eba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "607a4e8e73fa493ab5bbe4918e3859ac8187b6b95fc57a98c29d4543ae645116"
    sha256 cellar: :any_skip_relocation, sonoma:         "e263a0df69056309b6bcd0252dc73339e1af655f75290d8b63b0ea8d5ce0d452"
    sha256 cellar: :any_skip_relocation, ventura:        "0f678551dea503b83983527cdfc38f39c4850d2dcafaf9c8f10d94ccf22cd265"
    sha256 cellar: :any_skip_relocation, monterey:       "37d7b00c9b7f8b636e3df7a6140d2aa16bbbea2ed0c451ebc53604460e9a9cbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4d48a2c143ec075cfcbaf93a42cbec6404feb8a060c9c4708d710cdcb62c13b"
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
