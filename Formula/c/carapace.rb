class Carapace < Formula
  desc "Multi-shell multi-command argument completer"
  homepage "https://carapace.sh"
  url "https://github.com/carapace-sh/carapace-bin/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "135e51b0cb2bab633de7c82c8e7999d0c2d95e25d5226b2b7db3b10a6ce3dc28"
  license "MIT"
  head "https://github.com/carapace-sh/carapace-bin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03d7a445b8832a5aee95eb471bbbed7a8af9e166eb7f6cd674e48b2d544b05d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f763ff7b87e7ea24dcfd50a41c092f2be03d0c274b2be21d32ff808cc3d65409"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "656bc0552265aa928535d4ca80996d01e0d66e68f202220306b37888245b31f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "190c6238545b8b2aed0d68860f931423e1059822f7d48bebdb133953d477e623"
    sha256 cellar: :any_skip_relocation, ventura:       "c41711df004ef8bc179e76f810df5363ef03d1df8e9c061c3e73425d2320d5ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e55b78f161f80eee7c0a69a82a0d37c448e0a05359a75c0eb8e9bbf6eddab577"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "release"), "./cmd/carapace"

    generate_completions_from_executable(bin/"carapace", "_carapace")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/carapace --version 2>&1")

    system bin/"carapace", "--list"
    system bin/"carapace", "--macro", "color.HexColors"
  end
end
