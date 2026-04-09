class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https://github.com/suzuki-shunsuke/pinact"
  url "https://github.com/suzuki-shunsuke/pinact/archive/refs/tags/v3.9.0.tar.gz"
  sha256 "4e4f5f1f98162f90fe688d9a82f00da56e545e15bec8d3a0fa334b1c72b59aef"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/pinact.git", branch: "main"

  # Pre-release version has a suffix `-\d` for example `3.0.0-0`
  # so we restrict the regex to only match stable versions
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1f5c4b4b75404099ccb580789ee7eb9a3dbc9dd0fb111cd8bf2a0e47e5300f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1f5c4b4b75404099ccb580789ee7eb9a3dbc9dd0fb111cd8bf2a0e47e5300f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1f5c4b4b75404099ccb580789ee7eb9a3dbc9dd0fb111cd8bf2a0e47e5300f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "231632e3d6eddee72e5514544c06ef3d9f84ee92bd9d94a2d86e7fc66abba9df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e679fccf16aea372535b100c7136af9bf6854466ed52c5c826e81b8573bbfe30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4878d7a277b94b39a21923a39e0fb9eaa08e1dea34f672ece037312f5b306701"
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
