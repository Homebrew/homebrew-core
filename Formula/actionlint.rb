class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/v1.6.23.tar.gz"
  sha256 "6c85fda89e1a4fa1bed0d55a77739b538dd45de99979777139c9a2b47c20ec11"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79c0e241ada4f24e8614c4cef2a09422ebf933a58883b56c7b6921f5f44181b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79c0e241ada4f24e8614c4cef2a09422ebf933a58883b56c7b6921f5f44181b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79c0e241ada4f24e8614c4cef2a09422ebf933a58883b56c7b6921f5f44181b6"
    sha256 cellar: :any_skip_relocation, ventura:        "7e125c2458bc57faa4b6b7f64eb3ddbfe72b1e00b5d05c409e7de262d37200f2"
    sha256 cellar: :any_skip_relocation, monterey:       "7e125c2458bc57faa4b6b7f64eb3ddbfe72b1e00b5d05c409e7de262d37200f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e125c2458bc57faa4b6b7f64eb3ddbfe72b1e00b5d05c409e7de262d37200f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05272ca4340c73b96f907df2f3f111451ecf3126f3e6495e3cedc49e90425568"
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
