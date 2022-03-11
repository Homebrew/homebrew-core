class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/v1.6.10.tar.gz"
  sha256 "14a4648fc4e129d1e2f0c60b41995fdb6f66c94325e514fdffe011ac5c182092"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30473446b455a06239c74d71895c86e211b6dab0222debd159dbe28d3eb69227"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30473446b455a06239c74d71895c86e211b6dab0222debd159dbe28d3eb69227"
    sha256 cellar: :any_skip_relocation, monterey:       "c40ee32c7920312b277cc7b1548b6592b1a595547199f015aa2303ac80755b0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c40ee32c7920312b277cc7b1548b6592b1a595547199f015aa2303ac80755b0a"
    sha256 cellar: :any_skip_relocation, catalina:       "c40ee32c7920312b277cc7b1548b6592b1a595547199f015aa2303ac80755b0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73aa4a1855fe6d96aa9fc265b0722269fbb446d375b0dfc4340394c981b83885"
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
