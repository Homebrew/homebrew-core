class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/v1.6.3.tar.gz"
  sha256 "11dbfb81e8d0f28f5979437b9effadcd5dd692b8c033a6d7815210b982793d2a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8a190a4774f8e387b1b9a9a62f4142dc55b3dec07b459ed239cc81f54cf23e96"
    sha256 cellar: :any_skip_relocation, big_sur:       "1ee1ba4eacdb3c66c4823d7deb74e3e81a130f86991073a331fa231e0b851715"
    sha256 cellar: :any_skip_relocation, catalina:      "1ee1ba4eacdb3c66c4823d7deb74e3e81a130f86991073a331fa231e0b851715"
    sha256 cellar: :any_skip_relocation, mojave:        "1ee1ba4eacdb3c66c4823d7deb74e3e81a130f86991073a331fa231e0b851715"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "756f96db54523fb72427516142127de6eb93cc35f5e3bffa20502b34b0a7d5ee"
  end

  depends_on "go" => :build
  depends_on "ronn" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/actionlint"
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
