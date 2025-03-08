class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https://github.com/suzuki-shunsuke/pinact"
  url "https://github.com/suzuki-shunsuke/pinact/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "7dd89e7d32056a81d8adc500cd277ac7920999c80a187a5df3252419a10ebfba"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/pinact.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13fa4890f41e71f5aea2b8280511a331985cf6ea5206a5e2cb28fbcdbef92086"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13fa4890f41e71f5aea2b8280511a331985cf6ea5206a5e2cb28fbcdbef92086"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "13fa4890f41e71f5aea2b8280511a331985cf6ea5206a5e2cb28fbcdbef92086"
    sha256 cellar: :any_skip_relocation, sonoma:        "642c7a86251030a4af2d69359c3173f6f3210e851168d565f8cb063ef3758021"
    sha256 cellar: :any_skip_relocation, ventura:       "642c7a86251030a4af2d69359c3173f6f3210e851168d565f8cb063ef3758021"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "504a5b29485561ceee0562a0dc7e868d865a80e2b48c7e1c956ba0897bc35baf"
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
