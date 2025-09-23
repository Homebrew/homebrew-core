class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.12.1",
      revision: "39f7bbe2b07893e40300a75fc8915f3ff2677e5e"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1e80eb2b890049273deb35804bc4d2ea596d5b9ac068a4cb447100b3b7905f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1e80eb2b890049273deb35804bc4d2ea596d5b9ac068a4cb447100b3b7905f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1e80eb2b890049273deb35804bc4d2ea596d5b9ac068a4cb447100b3b7905f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "89b689aa89c883d354b1ccf5985c79bd38f49dad18ea86828142b6249a2c4dff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2d46c37dd1758f537f54d247bf719090d74ace278f6f51429307826d153df24"
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
