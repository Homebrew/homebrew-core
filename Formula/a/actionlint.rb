class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/v1.6.25.tar.gz"
  sha256 "7592aaddc49146b15a9822e97d90d917a1bd8ca33a4fb71cd98ef8c8c06eb3cf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a623d1bf1fb7f5dfb2ee2882d40bee9f57124c3d8d91752aedb7b05eae9bf65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a623d1bf1fb7f5dfb2ee2882d40bee9f57124c3d8d91752aedb7b05eae9bf65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a623d1bf1fb7f5dfb2ee2882d40bee9f57124c3d8d91752aedb7b05eae9bf65"
    sha256 cellar: :any_skip_relocation, ventura:        "b7e373f09ff18c1aee35403a6618030ccca7239206e9600db62a997cc269fc12"
    sha256 cellar: :any_skip_relocation, monterey:       "b7e373f09ff18c1aee35403a6618030ccca7239206e9600db62a997cc269fc12"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7e373f09ff18c1aee35403a6618030ccca7239206e9600db62a997cc269fc12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8d0dc4c6ce196df503d737db4c1986c31bd9d13f834797d113c00313f13bbeb"
  end

  depends_on "go" => :build
  depends_on "ronn" => :build

  def install
    ldflags = "-s -w -X github.com/rhysd/actionlint.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/actionlint"
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

    assert_match "\"runs-on\" section is missing in job", shell_output("#{bin}/actionlint #{testpath}/action.yaml", 1)
  end
end
