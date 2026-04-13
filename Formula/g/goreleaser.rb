class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.15.2",
      revision: "8620b255082c050ba3ff41e611f6e4b15846639d"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f5cc1fae598e485e9650960e38af73b3dbb18375eca69ff3493ac6564ecf68d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23677ed2d7fce2e6a608cdf0bcc8eabb9fb932dd4db90eb3fcf5e755b6a26caa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fdc2b1ba4cbc4b4b70570912ba32acc8aa783b009bd6d385bc87e5472459209"
    sha256 cellar: :any_skip_relocation, sonoma:        "37bbbb2ee49d0fa8ef05262a56cc2601c9f3999d9e82a1f46f3f63fb6db6107b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c1797251c1567f2f2a4d97e9100a16b04fd9fadb84e06f1c33f8f1ad37e803c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cd2b6ba54db968fccbbeac1cb649d22530447a68af4c52cd6bea004c6912e51"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{Utils.git_head} -X main.builtBy=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"goreleaser", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "thanks for using GoReleaser!", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_path_exists testpath/".goreleaser.yml"
  end
end
