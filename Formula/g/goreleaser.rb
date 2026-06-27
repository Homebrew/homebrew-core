class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.16.0",
      revision: "d76fb400136f96af3aaa7202776257885c9a6097"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5cec2ba08030226cc034c3d8961a862b20b01f7f749176acf047d5c6a3aa467a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a319bfff81a1cae3f9c14b1d9497783370dd93c220595c325a22bfedcc2b32e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4621ff1cdfa8a75227b6f358ec99a7e0698c72699aef0dc239f4f9b090fb12af"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed200ba76725cb40472e58429cfad196d4b4dc3f17bc322173b5d1a9df4f0362"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6cde000760bddfeca58bf974fb30b389a54350c0120ea2feae44d03e02bfb727"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18399388e05b0cab2a8769c86046c48c7cb23c1339fe06bdd4a67ed94cb3abab"
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
