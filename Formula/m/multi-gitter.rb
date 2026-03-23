class MultiGitter < Formula
  desc "Update multiple repositories in with one command"
  homepage "https://github.com/lindell/multi-gitter"
  url "https://github.com/lindell/multi-gitter/archive/refs/tags/v0.62.0.tar.gz"
  sha256 "9a86abe44035610e245e2b9df4992a84b10235a0b4bb00b8f79d1207cbaa6ed0"
  license "Apache-2.0"
  head "https://github.com/lindell/multi-gitter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12069a4cdf721d691623a94cb65e4380baaeb486d88f651153757a28de631663"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12069a4cdf721d691623a94cb65e4380baaeb486d88f651153757a28de631663"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12069a4cdf721d691623a94cb65e4380baaeb486d88f651153757a28de631663"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f1b2af98e8d1f5cfce25798650a5ec8838ee2a9d887c58fb2188297241e272c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30c3c2ddc609cd157da202aa9ed344caaf25c58e6a3696a5389a2950d9890391"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d789c65687898853c6220ded78f3dc999901abbcf39a464d7cdacde6766a265"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"multi-gitter", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/multi-gitter version")

    output = shell_output("#{bin}/multi-gitter status 2>&1", 1)
    assert_match "Error: no organization, user, repo, repo-search or code-search set", output
  end
end
