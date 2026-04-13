class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakend/krakend-ce/archive/refs/tags/v2.13.4.tar.gz"
  sha256 "c919ab2be3aa72c8204b7658e5e7f29e4978a21763c9e287dc2af0329ddea07f"
  license "Apache-2.0"
  head "https://github.com/krakend/krakend-ce.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "076d2dbccf924c778c6a5fa32f5758425f74214c8111c5866ef3343708f9e022"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6044f43774932bfc72d763773607e05c7247782a001b5fee72bbc7fabadfae6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cccccb0db39e781a0a024e51ea6457c068a80e7e0b4fb0e8807e454a0e4bdd00"
    sha256 cellar: :any_skip_relocation, sonoma:        "850e75b78353a767e45d1c609c46f943bd502585536be44a63b10471ef75af6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f49749947cc78caa0af3ea1aaf0cc0ef9c3089ca6e6b817c81d64a160f6f661b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54a348989ebef58e13b2b319d2d35c02a1ac4bd4564a4b6f1418048411cabce3"
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
