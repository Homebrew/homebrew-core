class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https://mindersec.github.io/"
  url "https://github.com/mindersec/minder/archive/refs/tags/v0.0.81.tar.gz"
  sha256 "41e75c3e4c41374071584a77decdbde411c2415d6a913ab1ba32c1644381f493"
  license "Apache-2.0"
  head "https://github.com/mindersec/minder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed246d841db2bdeb5ae1896c5f81e1e22a91e129c27e8991c4e0df387cf03877"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed246d841db2bdeb5ae1896c5f81e1e22a91e129c27e8991c4e0df387cf03877"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed246d841db2bdeb5ae1896c5f81e1e22a91e129c27e8991c4e0df387cf03877"
    sha256 cellar: :any_skip_relocation, sonoma:        "876681cc32a98361d683fc8098107cefe2e0bc2cb3095dc45c2213d6da4aafe5"
    sha256 cellar: :any_skip_relocation, ventura:       "a57221d441a1c72f5231bb7582efc384721f2cccc3f87920245d718cabea5a7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06c6e62bc1e0de949cd86555409d7b387868f1968373ce5273f656d1ffdd84ca"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/mindersec/minder/internal/constants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minder version")

    output = shell_output("#{bin}/minder artifact list -p github 2>&1", 16)
    assert_match "No config file present, using default values", output
  end
end
