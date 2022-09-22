class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/v1.6.19.tar.gz"
  sha256 "cd35e8fb32a2a4fecf6c380f85213acd0892a7cdc361ce41b9837edc726c9289"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50f7c74cd17bf6fd7c2913f9573aaccb8595e0575c8c4915ec4bd880fa976a72"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "50f7c74cd17bf6fd7c2913f9573aaccb8595e0575c8c4915ec4bd880fa976a72"
    sha256 cellar: :any_skip_relocation, monterey:       "dbe0374720cc62ef3d119d04850c620b8683d983e6086ec24bf3bbf5495f7d14"
    sha256 cellar: :any_skip_relocation, big_sur:        "dbe0374720cc62ef3d119d04850c620b8683d983e6086ec24bf3bbf5495f7d14"
    sha256 cellar: :any_skip_relocation, catalina:       "dbe0374720cc62ef3d119d04850c620b8683d983e6086ec24bf3bbf5495f7d14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a6156ec7f1d18335094f59e4b0b75b72fcbdb41f672b9f636f730646ac3374c"
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
