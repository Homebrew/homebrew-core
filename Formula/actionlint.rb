class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/v1.6.21.tar.gz"
  sha256 "731a3cd924a3be7b249f62b3a0cd88f6e2c642a305db9fc5e77169bd978394fb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b5aedea99e3c9c2de07cc747a37ad8b122fab2031756eb20889e18bc5ba4b3d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b5aedea99e3c9c2de07cc747a37ad8b122fab2031756eb20889e18bc5ba4b3d"
    sha256 cellar: :any_skip_relocation, monterey:       "fba6822e5210b4fd6d723d4e0eb542cc62f6bf52e28217f63a1a7ef6e62232d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "fba6822e5210b4fd6d723d4e0eb542cc62f6bf52e28217f63a1a7ef6e62232d3"
    sha256 cellar: :any_skip_relocation, catalina:       "fba6822e5210b4fd6d723d4e0eb542cc62f6bf52e28217f63a1a7ef6e62232d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81973ddbce5ba1329bfd30cd981a7fc36b096a5f74be7d7a5213e438a62b9857"
  end

  depends_on "go" => :build
  depends_on "ronn" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/rhysd/actionlint.version=#{version}"), "./cmd/actionlint"
    system "ronn", "man/actionlint.1.ronn"
    man1.install "man/actionlint.1"
  end

  test do
    (testpath/"action.yaml").write <<~EOS
      name: Test
      on: push
      jobs:
        test:
          steps:
            - run: actions/checkout@v2
    EOS

    assert_match "\"runs-on\" section is missing in job", shell_output(bin/"actionlint #{testpath}/action.yaml", 1)
  end
end
