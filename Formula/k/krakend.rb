class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakend/krakend-ce/archive/refs/tags/v2.13.10.tar.gz"
  sha256 "d380fd4f88cbf0a67d4b71b0728bf34faa67d3386db070985bb7239825edcefe"
  license "Apache-2.0"
  head "https://github.com/krakend/krakend-ce.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c46f75b051284155a78fb6d16c08b06eb68562c036b08b74407b38e85ffab6bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dab5f0b020a9aec4a3e5840b46133838765c4e3461dda5f66424cc5c53b180bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73785b0447acb059717cf3907f10eb30dbe4493163ea625e09021b2005136520"
    sha256 cellar: :any_skip_relocation, sonoma:        "10f3fa4d8527cdefd7786fcbd49b749e98c940c369fb8b3f1787cb602df60f40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a244483d85a2019f38c6421594ab53a19cb16d980d5acb73ebf32afb47091de"
    sha256 cellar: :any,                 x86_64_linux:  "db359f5f8fd01e82b9c3e74066553ec461d118ff55413cdb1fcdf921a3bf943d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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
