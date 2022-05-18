class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/v1.6.13.tar.gz"
  sha256 "ad0cf7ab26416df5abc4a0ded7bb416c834e57fcebfe330a335129e8d5a9c3bd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2509efcf0f383ccaf17b6472ae74760ca5094f80e5c6e04fbfbc039161cfe24e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2509efcf0f383ccaf17b6472ae74760ca5094f80e5c6e04fbfbc039161cfe24e"
    sha256 cellar: :any_skip_relocation, monterey:       "517066ddb464c9448e5e435248c6388c9899d7360ffc2b1d615d427a1e82072e"
    sha256 cellar: :any_skip_relocation, big_sur:        "517066ddb464c9448e5e435248c6388c9899d7360ffc2b1d615d427a1e82072e"
    sha256 cellar: :any_skip_relocation, catalina:       "517066ddb464c9448e5e435248c6388c9899d7360ffc2b1d615d427a1e82072e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac458a2cdfbda7c7b9b8804b5cf8e3cc77889bfc8d95aa7bc60f643c3012025f"
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
