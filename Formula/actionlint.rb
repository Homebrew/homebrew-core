class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/v1.6.9.tar.gz"
  sha256 "d1716db41b65ad60a4ae3cb0a3f9fb5f4ccc94171aff5525263d4b53eccbd2ac"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c006dfa8e4c35b1efaeff5234c0d873ea29a688ebb5bfc88c0f9d852aae0dbec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c006dfa8e4c35b1efaeff5234c0d873ea29a688ebb5bfc88c0f9d852aae0dbec"
    sha256 cellar: :any_skip_relocation, monterey:       "8c3769c93ff2881c78c436bbfb6fc9fb53345f6edcae4d4fa608919ed14dca19"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c3769c93ff2881c78c436bbfb6fc9fb53345f6edcae4d4fa608919ed14dca19"
    sha256 cellar: :any_skip_relocation, catalina:       "8c3769c93ff2881c78c436bbfb6fc9fb53345f6edcae4d4fa608919ed14dca19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12317262ea5f59415f13ee49329d9e5c221c553357d3875b35aab5d1af84756a"
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
