class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/refs/tags/v1.7.11.tar.gz"
  sha256 "a2c073d2aac12e9fe6b5b82f0bc1780d08b04bd6a331958cd783e46ee48e9cdf"
  license "MIT"
  head "https://github.com/rhysd/actionlint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3bb18b268cf8645a0318e4a929b9e0b53ce1aa0f429250cfdec77f91a4cd6c19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bb18b268cf8645a0318e4a929b9e0b53ce1aa0f429250cfdec77f91a4cd6c19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bb18b268cf8645a0318e4a929b9e0b53ce1aa0f429250cfdec77f91a4cd6c19"
    sha256 cellar: :any_skip_relocation, sonoma:        "5becd1a472ca94807b4382fdfef5d8836edd8838d80e158b41d665a9daae922d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc80a0e853ad651193f92c180a95a9f4d3f93fe0eba422c261dc908ecedd4a52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09a417b6ad3a2fc5583a4384c4817056f0fc9089a94a595aaa4fe3c9415e3184"
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
