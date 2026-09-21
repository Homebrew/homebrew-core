class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/fencesandbox/fence"
  url "https://github.com/fencesandbox/fence/archive/refs/tags/v0.1.67.tar.gz"
  sha256 "f2e55bd108816d224f45b3115e0c8feba2cb1a92055f0ebf7839f82b87a84f35"
  license "Apache-2.0"
  head "https://github.com/fencesandbox/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "21f1ad01228288ab353a3707e420f4b88957dc0152afa824b374594df2feed12"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fcc5f914430baffa9c9bef9b586a833ef0792c985835bc69f0bf52614b633db9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fcc5f914430baffa9c9bef9b586a833ef0792c985835bc69f0bf52614b633db9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "fcc5f914430baffa9c9bef9b586a833ef0792c985835bc69f0bf52614b633db9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "468be92c8e2f0351ce4af9ac725e0336fc168f4da8e4dd3021e24f8df3d4bd48"
    sha256 cellar: :any,                 x86_64_linux:      "eb63ada8d821232a17d6a1b951d3bc272f7312115c1c40b8f1f7c4f8a165f73a"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "bubblewrap" => :no_linkage
    depends_on "socat" => :no_linkage
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
