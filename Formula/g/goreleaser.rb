class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.20.2",
      revision: "1bf59683fabedd7b446d089ec31b1e343b472ce6"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ed3c35f71b98b639bb40ab02856696b66e3657a5d690524b17040d7f9345376c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bc32ecff26a02b9d09e559cc66a5ed54bdb6529162e439ac7d17470a9986f851"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "884666a551eebc455856d6600eb39f7a0c10455e2287f84e611d622014590a79"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0fa9addf46f1fc3239fd0c4eaf76d2e028c6ee8ce7d8bfe0c81f08dfbca5a472"
    sha256 cellar: :any,                 x86_64_linux:      "c5458edd58db85dfd6ae4a9f29910dfd937edf10f629ea988246da43aa90f1d9"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)

    generate_completions_from_executable(bin/"goreleaser", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "thanks for using GoReleaser!", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_path_exists testpath/".goreleaser.yml"
  end
end
