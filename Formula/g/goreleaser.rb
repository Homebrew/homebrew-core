class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.7.0",
      revision: "8aacb197877091cea0d18523ad672eb99087b18d"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abcbc8b2e3759ceacccb193aa4ce2cd857812279722d4f8f3b1d4fa26330e92d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abcbc8b2e3759ceacccb193aa4ce2cd857812279722d4f8f3b1d4fa26330e92d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "abcbc8b2e3759ceacccb193aa4ce2cd857812279722d4f8f3b1d4fa26330e92d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e89b55ea476a2e781e7cdd73fe1ff5f4fdd523062ecc12952913de05b9fad83"
    sha256 cellar: :any_skip_relocation, ventura:       "3e89b55ea476a2e781e7cdd73fe1ff5f4fdd523062ecc12952913de05b9fad83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4d33c6847200b1d66b4f50d51d603de229ce2ab85095da1e3f2695be7030433"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ]

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
