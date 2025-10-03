class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakend/krakend-ce/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "09a248acc24a752b91cc1cb06ee61731a40068b7b609ee8f00b91da4d845b53d"
  license "Apache-2.0"
  head "https://github.com/krakend/krakend-ce.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce68361f8453b5de7c034dbdb5e2433ad66a6d9a7d2d958812463908eaa7d99a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e920c97ee588bafad2566c80f19601213ff8882e88aaea9f37c1e7b4af57ec98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88f77c24db71dfea417882a7188b885be8b4163a836fd59e0a450fbd32209885"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0265af7445a32eb4bc70615c2978a8e8bbe6d275582386344fdbbeddee0fa91f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e6d86a34f5ea6e8e968be9fa1bc6fd1fb4f5cef76dbf7d380df07001bff9466"
    sha256 cellar: :any_skip_relocation, ventura:       "a630b77be843c9dbd2f551c05e90c8bac3cb5ee64cc7dc255749d47abc86d645"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3525bddd880e315a620d355323d5ab70b1757391bf6fdd30e5f327abe4a16dda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "909400c91de8443548a776159879d80721f93f86699b42eafe55256f803630fa"
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
