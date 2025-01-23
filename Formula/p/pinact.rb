class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https://github.com/suzuki-shunsuke/pinact"
  url "https://github.com/suzuki-shunsuke/pinact/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "baff7097239322f9402a07637dd0cf700473cd3e4e982c4592786dfebd87d28d"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/pinact.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a80c20655c50613257e73d435d8bc4923f88ecb9ab970fbd8a6c30c9dc062908"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a80c20655c50613257e73d435d8bc4923f88ecb9ab970fbd8a6c30c9dc062908"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a80c20655c50613257e73d435d8bc4923f88ecb9ab970fbd8a6c30c9dc062908"
    sha256 cellar: :any_skip_relocation, sonoma:        "0df3670013d1e15f2531c11f7a09980aadb6822c521513e6fa8f55b2d3cb0434"
    sha256 cellar: :any_skip_relocation, ventura:       "0df3670013d1e15f2531c11f7a09980aadb6822c521513e6fa8f55b2d3cb0434"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20205b699570a2b22bf3d6a81436efbf99aaaab2502692d5abc68d77d8a3f1f5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pinact"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pinact --version")

    (testpath/"action.yml").write <<~YAML
      name: CI

      on: push

      jobs:
        build:
          runs-on: ubuntu-latest
          steps:
            - uses: actions/checkout@v3
            - run: npm install && npm test
    YAML

    system bin/"pinact", "run", "action.yml"

    assert_match(%r{.*?actions/checkout@[a-f0-9]{40}}, (testpath/"action.yml").read)
  end
end
