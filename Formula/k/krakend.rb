class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakend/krakend-ce/archive/refs/tags/v2.13.8.tar.gz"
  sha256 "85420cc454e7a39fb0b4d4421bcb9ea4bcca559bc9787c62021bbaab2142ea7b"
  license "Apache-2.0"
  head "https://github.com/krakend/krakend-ce.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d01ce35c6d78264fef1872436ea8caecfcf52bd11758117208621c1d97985c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09fa1d82e77c60bb17ef459686bd6d735a81c6a64fed4cef8384125408291d28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c65769f947eba726cd7d1c4d89206a74d1c9ebc8e7e6b08f2a0a6dee3a4c6e1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e7087c681bebe2c4cda976d4fd1651e365d7e77948df038277e44ab0f9b7665"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e807f6aa132c21e18fa87b5f245503cfd11e946d6b38d802f3f1233c61c75073"
    sha256 cellar: :any,                 x86_64_linux:  "5b505baa23c8c84cd36dd74035c00a627d5b2d88e5dca5bc069ca3782b92c3b2"
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
