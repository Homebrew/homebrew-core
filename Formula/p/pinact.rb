class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https://github.com/suzuki-shunsuke/pinact"
  url "https://github.com/suzuki-shunsuke/pinact/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "2646a3857f59accf33812cb926ac8b1eb2d139de487686f08adff56c531eb83b"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/pinact.git", branch: "main"

  # Pre-release version has a suffix `-\d` for example `3.0.0-0`
  # so we restrict the regex to only match stable versions
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f2018bbe2bc5e1d9e6fbf3aa6e0d0274475a0ad2256103a618db3871d619eca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f2018bbe2bc5e1d9e6fbf3aa6e0d0274475a0ad2256103a618db3871d619eca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f2018bbe2bc5e1d9e6fbf3aa6e0d0274475a0ad2256103a618db3871d619eca"
    sha256 cellar: :any_skip_relocation, sonoma:        "d767c80b73165ba2c081b6e6f303e2ca6ec38a038ddcc54e71d238211d4852ad"
    sha256 cellar: :any_skip_relocation, ventura:       "d767c80b73165ba2c081b6e6f303e2ca6ec38a038ddcc54e71d238211d4852ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2c3ba968ebba6976188ea46f0a9a40abe5a7dd0d8a41202e508d13c68975b2e"
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
