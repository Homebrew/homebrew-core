class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.8.2",
      revision: "2d07c80923ac8a85886544b5dfb40160aa9ba90b"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "083f17d9d0b7b154c741fbc0d8e40bf2b34b03b22b8062624490bd97725258d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "083f17d9d0b7b154c741fbc0d8e40bf2b34b03b22b8062624490bd97725258d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "083f17d9d0b7b154c741fbc0d8e40bf2b34b03b22b8062624490bd97725258d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "6208f323e854126b1327f6f3158a5de3d799ace9358f50ec6276f773c6fdc48d"
    sha256 cellar: :any_skip_relocation, ventura:       "6208f323e854126b1327f6f3158a5de3d799ace9358f50ec6276f773c6fdc48d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f641fe9238fcfdc0c5869b078b462c2870b9a699da087a7b1bae2955684b640e"
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
