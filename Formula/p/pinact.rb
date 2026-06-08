class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https://github.com/suzuki-shunsuke/pinact"
  url "https://github.com/suzuki-shunsuke/pinact/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "880e29511209f1cb55ac53e4e72b9ee2c62c13340420ed3263b99302f9b71bd2"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/pinact.git", branch: "main"

  # Pre-release version has a suffix `-\d` for example `3.0.0-0`
  # so we restrict the regex to only match stable versions
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9875bd8ced96e98281f8a4a318f03cc41769dc75bc52c43f742c677c0c9cb0cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9875bd8ced96e98281f8a4a318f03cc41769dc75bc52c43f742c677c0c9cb0cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9875bd8ced96e98281f8a4a318f03cc41769dc75bc52c43f742c677c0c9cb0cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "539f3bafc8d88eacb630d6c4523e12143c3dd38777631e66e93aeba16fa5360a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8687895692a116bb1b0762fb771b9ffab4ab3f9f639697d6f82043a377ef3c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8c3d0a8402f6c27d140c920a4c22e634f1e6e9742780d9a00dc362f11cf0758"
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
