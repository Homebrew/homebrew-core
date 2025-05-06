class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakendio/krakend-ce/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "3495b24b7a4506b9c6eccdc39e2fb21f0425170ac0942185d975260dc9cf4069"
  license "Apache-2.0"
  head "https://github.com/krakendio/krakend-ce.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1936b4b8e16dd401160e37fc64147b173cb1a229c783323ce8490b344796b06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f67025ccba882e898086723f95ac596be9b8a732d092c1aec063928ca8f8fa9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "724406a542178c49e459a8d593da7eb4d38c582e1953f0c4f33c50e54e7a10e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a6b852318ad17ef331310546c8436ec2836687d0fe10690ae9c6ab30ebd9dc7"
    sha256 cellar: :any_skip_relocation, ventura:       "a16f3aa8a6fb755e7c753cfcc78cd8a028a2efcae819876314eac05d95aff2db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e284a7d0101c7194b71bbaa6d44ed27128eab2e920495ebd5b17ebd82b483497"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e662d80c809c9c872301a6d7a451db4242849bb6826fd423f7f2dc9606a6a30d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/krakendio/krakend-ce/v2/pkg.Version=#{version}
      -X github.com/luraproject/lura/v2/core.KrakendVersion=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/krakend-ce"
  end

  test do
    (testpath/"krakend_unsupported_version.json").write <<~JSON
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
    JSON
    assert_match "unsupported version",
      shell_output("#{bin}/krakend check -c krakend_unsupported_version.json 2>&1", 1)

    (testpath/"krakend_bad_file.json").write <<~JSON
      {
        "version": 3,
        "bad": file
      }
    JSON
    assert_match "ERROR",
      shell_output("#{bin}/krakend check -c krakend_bad_file.json 2>&1", 1)

    (testpath/"krakend.json").write <<~JSON
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
    JSON
    assert_match "Syntax OK",
      shell_output("#{bin}/krakend check -c krakend.json 2>&1")
  end
end
