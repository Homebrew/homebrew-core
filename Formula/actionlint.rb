class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/v1.6.15.tar.gz"
  sha256 "805fa0288162eb88ed390a1a8f6650d9f6aff3b3129831a882e9e93d7ad185f8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "661862ada11bd865c777d2b4c4efd33da20ca8113ba9245bb9b1f3fe39c9e33f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "661862ada11bd865c777d2b4c4efd33da20ca8113ba9245bb9b1f3fe39c9e33f"
    sha256 cellar: :any_skip_relocation, monterey:       "a773371ba12133a957968a65310fa190a68bcd023c6102666ec924ec3e59ea2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a773371ba12133a957968a65310fa190a68bcd023c6102666ec924ec3e59ea2d"
    sha256 cellar: :any_skip_relocation, catalina:       "a773371ba12133a957968a65310fa190a68bcd023c6102666ec924ec3e59ea2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2aef554b46fc05b18b6bc7137901189aab919c9ba6561f365ea140fb9d3ea5e"
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
