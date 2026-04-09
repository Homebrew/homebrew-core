class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/refs/tags/v1.7.12.tar.gz"
  sha256 "454800bd4f854592bcfe79b161f71d56e35940eb7016e48a26dd356adc9d400a"
  license "MIT"
  head "https://github.com/rhysd/actionlint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26f21384f90e1fe7e5848ccbbac509e0cba82ba74c69646cd4851710fadc5af2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26f21384f90e1fe7e5848ccbbac509e0cba82ba74c69646cd4851710fadc5af2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26f21384f90e1fe7e5848ccbbac509e0cba82ba74c69646cd4851710fadc5af2"
    sha256 cellar: :any_skip_relocation, sonoma:        "797ec6a88750f7a59e9c2505de5a6a1da1ac4e91d7637420b90eb105693c9992"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec7c45d83bbd0b7b62cb934893f04c15ff3e77d07f97bb519448f65e3da0abdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "facbd39a3a2cc99217cd995b80b9fc2970b8f41f589ca7622be272acafb6495a"
  end

  depends_on "go" => :build
  depends_on "ronn" => :build
  depends_on "shellcheck"

  def install
    ldflags = "-s -w -X github.com/rhysd/actionlint.version=#{version}"
    # FIXME: we shouldn't need this, but patchelf.rb does not seem to work well with the layout of Aarch64 ELF files
    ldflags += " -extld #{ENV.cc}" if OS.linux? && Hardware::CPU.arm?
    system "go", "build", *std_go_args(ldflags:), "./cmd/actionlint"
    system "ronn", "man/actionlint.1.ronn"
    man1.install "man/actionlint.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/actionlint --version 2>&1")

    (testpath/"action.yaml").write <<~YAML
      name: Test
      on: push
      jobs:
        test:
          permissions:
            attestations: write
          steps:
            - run: actions/checkout@v4
    YAML

    output = shell_output("#{bin}/actionlint #{testpath}/action.yaml", 1)
    assert_match "\"runs-on\" section is missing in job", output
    refute_match "unknown permission scope", output
  end
end
