class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/v1.6.7.tar.gz"
  sha256 "21550aae8fc0369072b865e2f75b6064ad382314143e6c02d14791606af92759"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa3ef1e70003fd7f6d3acb239a61643d9a2f7ced9c3c5e867a626d3225b7be2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa3ef1e70003fd7f6d3acb239a61643d9a2f7ced9c3c5e867a626d3225b7be2e"
    sha256 cellar: :any_skip_relocation, monterey:       "0a8ecc15685af87c7a1ab8680e886a3cf010dbf74d7fd308b13874bc78850d7f"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a8ecc15685af87c7a1ab8680e886a3cf010dbf74d7fd308b13874bc78850d7f"
    sha256 cellar: :any_skip_relocation, catalina:       "0a8ecc15685af87c7a1ab8680e886a3cf010dbf74d7fd308b13874bc78850d7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c197da159e7a26b5dcfb91e260bb7ede4ddb538f2a32cd9b6d866c3c88d92808"
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
