class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/v1.6.18.tar.gz"
  sha256 "2ea2c10ef24c53b8366d254674337e69f291be41a879949484cd9c11d74e8d7e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da1d6483e8ba4efcb8bb5e51465f4216aad19e82f320e195c12c0c2bc5ef82cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da1d6483e8ba4efcb8bb5e51465f4216aad19e82f320e195c12c0c2bc5ef82cf"
    sha256 cellar: :any_skip_relocation, monterey:       "e0227bf76ed374381ef117b0f57b2c72027e96ddcb1d4a40a13ed2f5bd7842ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0227bf76ed374381ef117b0f57b2c72027e96ddcb1d4a40a13ed2f5bd7842ae"
    sha256 cellar: :any_skip_relocation, catalina:       "e0227bf76ed374381ef117b0f57b2c72027e96ddcb1d4a40a13ed2f5bd7842ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f44ec9e28d13e5a38464ca1ea3d230fb422aa4f8100942987bf40c3d5bf840ee"
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
