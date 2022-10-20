class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/v1.6.21.tar.gz"
  sha256 "731a3cd924a3be7b249f62b3a0cd88f6e2c642a305db9fc5e77169bd978394fb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38e835c49a82c25eb10c7b9a1d21ad4ef542ed4311ef3fdfa158cb2584dcf21e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38e835c49a82c25eb10c7b9a1d21ad4ef542ed4311ef3fdfa158cb2584dcf21e"
    sha256 cellar: :any_skip_relocation, monterey:       "410d87c1137d1a879ee9fe3d971f33fd1ac78d7d472fde0882d1f3a897640a26"
    sha256 cellar: :any_skip_relocation, big_sur:        "410d87c1137d1a879ee9fe3d971f33fd1ac78d7d472fde0882d1f3a897640a26"
    sha256 cellar: :any_skip_relocation, catalina:       "410d87c1137d1a879ee9fe3d971f33fd1ac78d7d472fde0882d1f3a897640a26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0111d8cfadcdad3ffc17e6183f5f3ec597638c614dc011b2e18861017e11fa09"
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
