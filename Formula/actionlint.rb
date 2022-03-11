class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/v1.6.10.tar.gz"
  sha256 "14a4648fc4e129d1e2f0c60b41995fdb6f66c94325e514fdffe011ac5c182092"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f5d508ee60822ad1e911536196ba3e98d3791c57fa1deb56cc116a9b5c921e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f5d508ee60822ad1e911536196ba3e98d3791c57fa1deb56cc116a9b5c921e5"
    sha256 cellar: :any_skip_relocation, monterey:       "f72c93942fcb19482fc763395d6963cb5e7fc512115750dca5aadcbc0f1d4a64"
    sha256 cellar: :any_skip_relocation, big_sur:        "f72c93942fcb19482fc763395d6963cb5e7fc512115750dca5aadcbc0f1d4a64"
    sha256 cellar: :any_skip_relocation, catalina:       "f72c93942fcb19482fc763395d6963cb5e7fc512115750dca5aadcbc0f1d4a64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c1e36d9f3b769f4ef0f79abe61eb9cec7a3a2f8cdda561a1f8a3bb92573ce4e"
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
