class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.49.tar.gz"
  sha256 "a3532fc08b49de853965972a2bfc4cdb6c72b3edd6ff23b757a079663d1ac0db"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85d95f7cea34269e9c5be887c5b318b44440421d2365fc28d3378f9ffd708b7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85d95f7cea34269e9c5be887c5b318b44440421d2365fc28d3378f9ffd708b7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85d95f7cea34269e9c5be887c5b318b44440421d2365fc28d3378f9ffd708b7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2af9be6c7387c8b29e7de624f1a62913784ba418312488131a14f996a8da26b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4de03ee23db572c07e9107bb3a175454fca586fca820001219ea8679d9b6621"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a42aba0c2a7335e8a59d851402723e7cdf6d8601f217d787d69d1b21a413590"
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
