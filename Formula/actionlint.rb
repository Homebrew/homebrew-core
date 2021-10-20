class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/v1.6.6.tar.gz"
  sha256 "af5c9e93053c16204d9d92d3dbc7bb3c1cd65f259d294a69e45af45113fd79ad"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d63e74ca7623ab80f10e293947a7e397a33f2dc5a7193c63ed303c5d799a3318"
    sha256 cellar: :any_skip_relocation, big_sur:       "fd683adc5b4b9b05915d8df60de311c22c5e945f2f222497d887b145cd160d77"
    sha256 cellar: :any_skip_relocation, catalina:      "fd683adc5b4b9b05915d8df60de311c22c5e945f2f222497d887b145cd160d77"
    sha256 cellar: :any_skip_relocation, mojave:        "fd683adc5b4b9b05915d8df60de311c22c5e945f2f222497d887b145cd160d77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7a8893c093a81d33fdc180a79de742930db5a2c173ab7bf8a4567eff0108e75"
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
