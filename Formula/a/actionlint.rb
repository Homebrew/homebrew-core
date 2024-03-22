class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/refs/tags/v1.6.27.tar.gz"
  sha256 "211618132974a864e3451ecd5c81a6dc7a361456b5e7d97a23f212ad8f6abb2d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47307860c82d9cdb8cf666f8874900d587123238da9454d15051df85b846576b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47307860c82d9cdb8cf666f8874900d587123238da9454d15051df85b846576b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47307860c82d9cdb8cf666f8874900d587123238da9454d15051df85b846576b"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd8948dbc0b585c7936af8a0d4adbbbd2598e82927aec5256122d5c526bd1092"
    sha256 cellar: :any_skip_relocation, ventura:        "cd8948dbc0b585c7936af8a0d4adbbbd2598e82927aec5256122d5c526bd1092"
    sha256 cellar: :any_skip_relocation, monterey:       "cd8948dbc0b585c7936af8a0d4adbbbd2598e82927aec5256122d5c526bd1092"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2174334ae7aa23ee7282a5725935aae0092ea42166a0889bf51c127d0b3271b9"
  end

  depends_on "go" => :build
  depends_on "ronn" => :build

  def install
    ldflags = "-s -w -X github.com/rhysd/actionlint.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/actionlint"
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
