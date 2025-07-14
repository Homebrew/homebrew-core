class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakend/krakend-ce/archive/refs/tags/v2.10.1.tar.gz"
  sha256 "1fa65d8bc41aefba3264762acffabbc6f06d1ca1228c2ad71d3fc2118af8bec2"
  license "Apache-2.0"
  head "https://github.com/krakend/krakend-ce.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2244be62e6e2879367218e39e29ee83c8428fe2a3fda096a65205be1974429ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0b77c4d61c7da6e02d8da83e510759e1de52e5fcc86cd6aa337f8c34c49d9f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4e7a60fb925b9293c48480c648c5fb2f1d27fba8504e70827558cedbad7e7982"
    sha256 cellar: :any_skip_relocation, sonoma:        "7db6e72b5d1ae367b40e233d1e17197f489ee1d34aa73260628e520fe6cdf0f6"
    sha256 cellar: :any_skip_relocation, ventura:       "41b11391cb8ee48c390cc14f4f6b0cb2f664ece0d71d5bceaf6d0f6ee0bdd44a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a8931a602e13dcf42d0b12ee150b1297c753df2703717452d266379f62bd9f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66b354c4a36f74a5aada12edff011b115cce098a288bd504ffc9c73b4af5a0d9"
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
