class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https://github.com/suzuki-shunsuke/pinact"
  url "https://github.com/suzuki-shunsuke/pinact/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "0305c7db5cfcb2a62f7f5faa74e7cc3312c9ec10cbe01eadc23128d6a119eb03"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/pinact.git", branch: "main"

  # Pre-release version has a suffix `-\d` for example `3.0.0-0`
  # so we restrict the regex to only match stable versions
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "524de6301190cc19d33622f0999ca2d0510dbe2c09d7680778eacc8d1f18038f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "524de6301190cc19d33622f0999ca2d0510dbe2c09d7680778eacc8d1f18038f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "524de6301190cc19d33622f0999ca2d0510dbe2c09d7680778eacc8d1f18038f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1dde489434d359e3c334c64049055db6b297410082fc6ed4178146669353886"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee3f900d8ee571187d0f1ac834740be8dcbe29c94d6b602b0ae9bffdfcaea3f2"
    sha256 cellar: :any,                 x86_64_linux:  "af3670affe8038ae4004dd9770f1047e15e4d3593ce4e1f77ae0dc23aa1444d0"
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
