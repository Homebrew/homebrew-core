class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakendio/krakend-ce/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "d00c539c911c9a92867af2850fc4141a0f258b305d1bd840f8e4a3b5ddc335aa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e24372a69574f49b53d32316d2946b346fb0c0abfa3448c1384958eac9bf58de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03113f7be6b5e645707bf6fd28dc8927a9ea97ac4a261e4bf01db0e7ed7b9301"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "169048d68b2a235b93b6385ff33381a379e950279922a489567ad7f7fcb2867a"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbfd2178b5a6c020f21d25021314abd48fdd028ace2027a128901ce8bc362c9c"
    sha256 cellar: :any_skip_relocation, ventura:       "c0933c5ce0061fe898d8b655ce3f6b913205335a225153dcdae5f0f37ea6fe9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab37de42bb1df6f2958f9edbfc42850bbb6761e7ee100251229286c18431d052"
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
