class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https://github.com/suzuki-shunsuke/pinact"
  url "https://github.com/suzuki-shunsuke/pinact/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "e2a892491e94d38b2906d73f54136833831b5ee8a32914c14444ec7876522590"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/pinact.git", branch: "main"

  # Pre-release version has a suffix `-\d` for example `3.0.0-0`
  # so we restrict the regex to only match stable versions
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5584d6f693b82d02a61c5d4e9927e65aa11ef7e4a98884a2a05633e180d2f540"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5584d6f693b82d02a61c5d4e9927e65aa11ef7e4a98884a2a05633e180d2f540"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5584d6f693b82d02a61c5d4e9927e65aa11ef7e4a98884a2a05633e180d2f540"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee713c350ce8c2d9db2866a7fcd0e9af4d985cef1cb2976f7043976bf13698b5"
    sha256 cellar: :any_skip_relocation, ventura:       "ee713c350ce8c2d9db2866a7fcd0e9af4d985cef1cb2976f7043976bf13698b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe365e7daffba61ab1c9e8dde4e9ca1f29934ea67235079768547b55843ff884"
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
