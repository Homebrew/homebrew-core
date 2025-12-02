class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/refs/tags/v1.7.9.tar.gz"
  sha256 "3decd3ee2ef2e7382dee8c09994ad9f5a3c456751efbe2ba39fef7f1305703c0"
  license "MIT"
  head "https://github.com/rhysd/actionlint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b6e50d0062a371815a9fef0b36e001d00b2ccfdaf7a612ee61cfba9a7d69d91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b6e50d0062a371815a9fef0b36e001d00b2ccfdaf7a612ee61cfba9a7d69d91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b6e50d0062a371815a9fef0b36e001d00b2ccfdaf7a612ee61cfba9a7d69d91"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fcefe44394c93ed610d0330ba64afa1b48187e7864ded71d26674240585a44f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36550a3e2e1e11aa4828a3d574447edb824414be6d56ad9270c3ff6679628622"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f1dc15c148fc66393f782c1537f745b53a6bd2f3485763a7f91734ae1cdc41c"
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
