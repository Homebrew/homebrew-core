class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakend/krakend-ce/archive/refs/tags/v2.13.3.tar.gz"
  sha256 "9ff69b2b466e51fe7e1c2f653529300ecae5e4661cf8b434dbfd0757c268dfd5"
  license "Apache-2.0"
  head "https://github.com/krakend/krakend-ce.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5a9f02a6e3e00ec1f7bcef403d9db8f167f3964d170e785d7b585b5e95763a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16d81a2195f971f3cfd459ae98df5463db805afafa7cb48ee2b80d1bc7605c94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "954a83b0959b5bca334dff7a48395b81e1d530130bdd7b8b6720519d23bea313"
    sha256 cellar: :any_skip_relocation, sonoma:        "df6aca6499e5577c86c193b7b815382545a4e98c8b65fe601f29e4033ca3eb7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9232f36dc5286160dff2b1e493164b5493fd9a143fc9e1f8c07a08a20ea75864"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1218c711a3dc2f1f5eb1207c627c153df4fa2979a1d907450a40da22244031b4"
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
