class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.24.0",
      revision: "00c2ff733758f63201811c337f8d043e8fcc9d58"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "691cad59ceff1dd20fa7dd77b5fba6cc86bef9c46eb99f00c8e03c337f2be9a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cca78355485d4dbc91645242ddb6931a6fae6b9750933f51dd58909bc5f983f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a85a9da31d144136def8b76a96ee6319aa3858bcdcfccc8a0ca7190e92669635"
    sha256 cellar: :any_skip_relocation, sonoma:         "32d76ff4ad41ae366763b33d6f4da870f9554e725d1ea26d92fc5fe646a6b287"
    sha256 cellar: :any_skip_relocation, ventura:        "69a36098a9ef11090ccce9bce15a95a584d3869d60157ba20c4ced17a4a75220"
    sha256 cellar: :any_skip_relocation, monterey:       "ed30332a3a6dfca05ec937ee4370d37d403c63e9f1d362a74a254402b6ebec12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "807231bc781be1bbc4554c97ea4a7e91cfbeede6cb59bab73ad911bc23f39984"
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
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
