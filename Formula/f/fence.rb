class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.36.tar.gz"
  sha256 "0ca12bcbf89ab0054d42089260a6e90a7c10735b509792d3f91e1743f570f231"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0df452f90566a0dc2d8d274241988fc5089545a46c40e877595506423cf7ca3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0df452f90566a0dc2d8d274241988fc5089545a46c40e877595506423cf7ca3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0df452f90566a0dc2d8d274241988fc5089545a46c40e877595506423cf7ca3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9be504db02d762d96aff9901c60b9382f474f6aedaef0958ca1d17a48090efa6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05b5caaf7c9d6e5f4fc674484b79535faac16345dfd8b6a4c84eb5d65887c695"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbaff6ef3de6acb9bd6026ba7e081187747e89dac81628186043d7de29cf9178"
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
