class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/v1.6.13.tar.gz"
  sha256 "ad0cf7ab26416df5abc4a0ded7bb416c834e57fcebfe330a335129e8d5a9c3bd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ee0780acdb423acf0329f02da5b60fad7acaeae678bba15d5f19737c314a6c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ee0780acdb423acf0329f02da5b60fad7acaeae678bba15d5f19737c314a6c4"
    sha256 cellar: :any_skip_relocation, monterey:       "a73599118cd2f1069e6ba52bafa4947a4f78d272f8e2de4de6b025ab8b289467"
    sha256 cellar: :any_skip_relocation, big_sur:        "a73599118cd2f1069e6ba52bafa4947a4f78d272f8e2de4de6b025ab8b289467"
    sha256 cellar: :any_skip_relocation, catalina:       "a73599118cd2f1069e6ba52bafa4947a4f78d272f8e2de4de6b025ab8b289467"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "228ea1c2d977b107a83451d5d709b07f4ff2d177bceeb073b16af532ab596d43"
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
