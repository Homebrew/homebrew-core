class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.13.0",
      revision: "6e5e0aa6acd115c0b957ef269aad54493781cc7e"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e277e865858c181c4fc7f226967e17f46480857990f49418f7008efe40ea0c02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e277e865858c181c4fc7f226967e17f46480857990f49418f7008efe40ea0c02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e277e865858c181c4fc7f226967e17f46480857990f49418f7008efe40ea0c02"
    sha256 cellar: :any_skip_relocation, sonoma:        "030758d88d93f72390441109d62f4af190177a1ef93d09865d48ac1c4e223036"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8010bb9ebfc7ebd6071ca44947f40964142154ca6adc0add648512c2ecef57ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f8427618cfc40cd93132242c7a8c6ce82fc06e8c71926323cf4d18a1aa704bf"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{Utils.git_head} -X main.builtBy=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin/"goreleaser", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "thanks for using GoReleaser!", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_path_exists testpath/".goreleaser.yml"
  end
end
