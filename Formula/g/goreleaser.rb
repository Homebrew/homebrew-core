class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.11.0",
      revision: "bbd96a824a97ae622b4036c415285625b26e1868"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37243367d2ce12016dc11a8a2f3d09a21a6b7238754a9e125679a9e48b190df0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37243367d2ce12016dc11a8a2f3d09a21a6b7238754a9e125679a9e48b190df0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "37243367d2ce12016dc11a8a2f3d09a21a6b7238754a9e125679a9e48b190df0"
    sha256 cellar: :any_skip_relocation, sonoma:        "66990302e0621b4b8e59c4efebf6f9d65c35bef96f938ab5435008de78e43af2"
    sha256 cellar: :any_skip_relocation, ventura:       "43e5fa658e257418b46357938666e20e0b687724eb9a5c76dce22a9b652fed15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbb654237e7b55308dec9da6da22491c649ecdc641fe712cc954290170b39e7e"
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
