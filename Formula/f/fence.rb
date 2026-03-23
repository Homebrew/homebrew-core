class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.37.tar.gz"
  sha256 "89aff5121a0f641457f9d0da4f1e7f705e0f1025350601a3c7e541af906aa72e"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3c885a6ab489c3be558b9c12bed9e85aed986094652096c7ff1c5a0bdf1203c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3c885a6ab489c3be558b9c12bed9e85aed986094652096c7ff1c5a0bdf1203c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3c885a6ab489c3be558b9c12bed9e85aed986094652096c7ff1c5a0bdf1203c"
    sha256 cellar: :any_skip_relocation, sonoma:        "59264cb64316f91690dde4556454c858ef6605eef64337eac06cca102a1562a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "338d65b51d6390757ccb97af43afcb1275d2900d564d1a8966fdb391920fb2be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c72d4aab4a79ffe3ed9f27e07f28531ccd8b597ce6a9daabe03080b0b62bf20d"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "bubblewrap" => :no_linkage
    depends_on "socat" => :no_linkage
  end

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.buildTime=#{time.iso8601}
      -X main.gitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/fence"

    generate_completions_from_executable(bin/"fence", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fence --version")

    # General functionality cannot be tested in CI due to sandboxing,
    # but we can test that config import works.
    (testpath/".claude/settings.json").write <<~JSON
      {}
    JSON
    system bin/"fence", "import", "--claude", "-o", testpath/".fence.json"
    assert_path_exists testpath/".fence.json"
  end
end
