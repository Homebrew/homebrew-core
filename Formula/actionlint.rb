class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/v1.6.20.tar.gz"
  sha256 "d7e321ecfee8d8dc321212f3af46112e9214f824adce9db9aff1d4b1d73cbea1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6020b4927b3c1502137ea7a331ffba1c247f887a40aa81663e4ebba6335bff26"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6020b4927b3c1502137ea7a331ffba1c247f887a40aa81663e4ebba6335bff26"
    sha256 cellar: :any_skip_relocation, monterey:       "c542802a22508918047ec89616378fb63d511c34011b9564658065312ff56bf1"
    sha256 cellar: :any_skip_relocation, big_sur:        "c542802a22508918047ec89616378fb63d511c34011b9564658065312ff56bf1"
    sha256 cellar: :any_skip_relocation, catalina:       "c542802a22508918047ec89616378fb63d511c34011b9564658065312ff56bf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aed5f3250af3805b72b68f8bb881d021378ac6cc38d4919ae4066b7fe6808912"
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
