class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/v1.6.17.tar.gz"
  sha256 "319a34fd0320bd55580962cec12cc593c13c45f4674472e396dc845238b3d86c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abae31d37d778cb38a8d2e26b9edcee486fb9c19cba99db1a606664280b76867"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abae31d37d778cb38a8d2e26b9edcee486fb9c19cba99db1a606664280b76867"
    sha256 cellar: :any_skip_relocation, monterey:       "108705fc13a8481a5a265a2504981f9ace88cde1c5f40dfb9f41742c4eee5108"
    sha256 cellar: :any_skip_relocation, big_sur:        "108705fc13a8481a5a265a2504981f9ace88cde1c5f40dfb9f41742c4eee5108"
    sha256 cellar: :any_skip_relocation, catalina:       "108705fc13a8481a5a265a2504981f9ace88cde1c5f40dfb9f41742c4eee5108"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "278cee060ea063e951773a054bd02fe3ec593e0c04489699f4a7858603cdf529"
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
