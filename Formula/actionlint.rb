class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/v1.6.24.tar.gz"
  sha256 "0dc8b31c8541a719486b5678e6f0401c8c13ce7baf79013570f3799f380c1dc1"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3889ec9044a69b18fa9d61fa371cbff4438ec7c095db01ba476b73261e5f7fb9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3889ec9044a69b18fa9d61fa371cbff4438ec7c095db01ba476b73261e5f7fb9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3889ec9044a69b18fa9d61fa371cbff4438ec7c095db01ba476b73261e5f7fb9"
    sha256 cellar: :any_skip_relocation, ventura:        "0ce064aabda0438f12fd4b8dbc54b287286f70a09abed2d5067aad3a06feda58"
    sha256 cellar: :any_skip_relocation, monterey:       "0ce064aabda0438f12fd4b8dbc54b287286f70a09abed2d5067aad3a06feda58"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ce064aabda0438f12fd4b8dbc54b287286f70a09abed2d5067aad3a06feda58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9d2dbe78ce86aa3896945ed42f5db165fbcb4a29a13bf72db4e1b9fd300c9da"
  end

  depends_on "go" => :build
  depends_on "ronn" => :build

  # Support macos-13 GitHub-hosted runners.
  # Remove at next release.
  patch do
    url "https://github.com/rhysd/actionlint/commit/7aab63e3872d169984ad86d10db293355f24fb7b.patch?full_index=1"
    sha256 "b54f30a848db091915008abd435fa36c1b73e087a85b9a90ba358243afa6ad6f"
  end

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
