class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.12.7",
      revision: "e993642bd640f7e86f30d9d68de6e8f537de1178"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e64fcee0e48d552888cf3f0650ee29e277f02901f40f4fb3a17994a45b276625"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e64fcee0e48d552888cf3f0650ee29e277f02901f40f4fb3a17994a45b276625"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e64fcee0e48d552888cf3f0650ee29e277f02901f40f4fb3a17994a45b276625"
    sha256 cellar: :any_skip_relocation, sonoma:        "36beac688e5fc5cf3d4c46bbaad584b9be6ad43a35e68604812e1d2df3c07958"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ba2d72688eb7f27eed0ac2d7ba1300d274d82d79d77dc879be41ad9a34849ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a62ba41f23774797f35ebb46a6b863d8e383e59fd2c3771ff6f1e4596b334809"
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
