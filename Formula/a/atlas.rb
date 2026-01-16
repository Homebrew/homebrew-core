class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https://github.com/ariga/atlas/issues/1090#issuecomment-1225258408
  url "https://github.com/ariga/atlas/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "06c0d2488147466d88aaf14d7ecd6ea9f7f94763cfa45b88689d299b9a496e1b"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76dc3ad810709204c2e8bda197effd2a4b2280272f03ba6656fed3efd35c135f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "620d120ae8edbfdfb4966dcd600aaff413abb1e2a48f50ab3cab7a9048e0b8a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f97878d9a446e154dc76e978e5a18e3dc4bbc9fb74473187383ed9f2d01b33ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "6cbc5c0a63215e0cdece14f92d419149316f3426cdc95729463f9cfd5c148588"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de49555e8a1cf3a1d64172ad9f473d2e07b27a8513fbdc56134174783290d8da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4c654cf0302eb8fcf3d458cb3a1177f5660019365f9f503d69ae6b1869d62fd"
  end

  depends_on "go" => :build

  conflicts_with "mongodb-atlas-cli", "nim", because: "both install `atlas` executable"

  def install
    ldflags = %W[
      -s -w
      -X ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v#{version}
    ]
    cd "./cmd/atlas" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"atlas", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -u \"mysql://user:pass@localhost:3306/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end
