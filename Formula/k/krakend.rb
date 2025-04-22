class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakendio/krakend-ce/archive/refs/tags/v2.9.4.tar.gz"
  sha256 "95e0f124cbced45bf846e94fc3386f559a796c8b11f0238465620456810d2ad3"
  license "Apache-2.0"
  head "https://github.com/krakendio/krakend-ce.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8319093cf60758bbef672aaddc75bbf69a4db8fa58e45e67fdd60939f3c810cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e10e0a15633b333e065a0d5e5856691c1df8fcc1567fc1673d61ce9f22be04e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "799f816ec2a421dc42294d48df56c8e3c12c04800a1b7c4a9518cfa598b7c000"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce68340beef9c78686a40e1893c44adad0670c045f62f8b23cb79f99acfc7c99"
    sha256 cellar: :any_skip_relocation, ventura:       "a4f851447324024b948bebb1da8148fde8f688d0170c45031a3563ab5076cd81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c348a4ff5c0e831bc0559650c7fb6a0ebb9885b2e604017c2b8fd36087fde7a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d68285c7fd8fdb9780ab2af44270f0c3583d99237ec22802e30c9237ef938453"
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
