class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/refs/tags/v1.7.12.tar.gz"
  sha256 "454800bd4f854592bcfe79b161f71d56e35940eb7016e48a26dd356adc9d400a"
  license "MIT"
  head "https://github.com/rhysd/actionlint.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf32eeac6a6f6dcd816944d78ad0c1553952c3c2b5c72c71ea4fb71aa777ca75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf32eeac6a6f6dcd816944d78ad0c1553952c3c2b5c72c71ea4fb71aa777ca75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf32eeac6a6f6dcd816944d78ad0c1553952c3c2b5c72c71ea4fb71aa777ca75"
    sha256 cellar: :any_skip_relocation, sonoma:        "288e9dd084bbc163fe8be8cf49817b1db5cca7ce47366b0dc2c499be59c3ef91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fd8db6e4cf4685bea81a6225478b142635d8b9bd14cb664101a870760e57a21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d32ef049f0af2e06ab5f948e1850988f4e9ffb758f26e86279c7ebc395c25b7"
  end

  depends_on "go" => :build
  depends_on "ronn" => :build
  depends_on "shellcheck"

  deny_network_access! [:postinstall, :test]

  def install
    ldflags = %W[
      -s -w
      -X "github.com/rhysd/actionlint.version=#{version}"
      -X "github.com/rhysd/actionlint.installedFrom=installed from Homebrew"
    ]
    # FIXME: we shouldn't need this, but patchelf.rb does not seem to work well with the layout of Aarch64 ELF files
    ldflags << " -extld #{ENV.cc}" if OS.linux? && Hardware::CPU.arm?
    system "go", "build", *std_go_args(ldflags:), "./cmd/actionlint"
    system "ronn", "man/actionlint.1.ronn"
    man1.install "man/actionlint.1"
  end

  test do
    output = shell_output("#{bin}/actionlint --version 2>&1")
    assert_match version.to_s, output
    assert_match "installed from Homebrew", output

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
