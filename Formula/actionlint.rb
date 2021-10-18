class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/v1.6.6.tar.gz"
  sha256 "af5c9e93053c16204d9d92d3dbc7bb3c1cd65f259d294a69e45af45113fd79ad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d1f4dc010a666c7451b676689ac73f9a853888dbcc8909e49ffb45360e499a75"
    sha256 cellar: :any_skip_relocation, big_sur:       "c7dcceca206182819adeca34eeaac7b9c9ee1fe9136ebcfa66be56389319ffa9"
    sha256 cellar: :any_skip_relocation, catalina:      "c7dcceca206182819adeca34eeaac7b9c9ee1fe9136ebcfa66be56389319ffa9"
    sha256 cellar: :any_skip_relocation, mojave:        "c7dcceca206182819adeca34eeaac7b9c9ee1fe9136ebcfa66be56389319ffa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e193a56d54c710673de9d8f49c346ad7b62a59a03c54aaf208872ff6e39024d7"
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
