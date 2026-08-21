class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.17.1",
      revision: "83f4c19a5c5c0b9efef6bf2aedc6805bbcb9dfe2"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "131972d6069a7a979817816e3cb0950a89c2882921d95b22d7d0b2683768a8d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ad277cc0a162929e8ed301ef1f752358cf29049d179a2375cff64f5506534f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2477af1e85d81a6d4d1062659dae50389d715a76868d62d30f4612f65f8fc04"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d6f01221a773ee939e9b736747789813e43d94819536de7c633fc63718e42f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ef27caf1e236735aebbea26aaeb63f41846239d124829c22783f69542f1eafc"
    sha256 cellar: :any,                 x86_64_linux:  "a5585af5c80727793dbd106b201686adcd61fce051817690d144d0d8ae995238"
  end

  depends_on "go" => :build

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
