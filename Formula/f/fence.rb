class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/fencesandbox/fence"
  url "https://github.com/fencesandbox/fence/archive/refs/tags/v0.1.66.tar.gz"
  sha256 "a6ce458254ba8d74b84f40f5e99bd2f88fd2e71c8a7ca0962e3260c0b6d6fcaf"
  license "Apache-2.0"
  head "https://github.com/fencesandbox/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a68331e8280c1584b8e872b5758c548818b7b1bd887a52a54a5a6273f9e48a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a68331e8280c1584b8e872b5758c548818b7b1bd887a52a54a5a6273f9e48a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a68331e8280c1584b8e872b5758c548818b7b1bd887a52a54a5a6273f9e48a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f10a185f7df70004efef219036bf8343824e8cc9a568396df3ee09f544dcd30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "688ac5d62d99f8a36cd9140e5556f6aaba252b0addb836fbe89d12b6c69d572a"
    sha256 cellar: :any,                 x86_64_linux:  "d35518b98104f3e3d610433c6edcee50555c5f7865b3b8c7a143726a1229d642"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "bubblewrap" => :no_linkage
    depends_on "socat" => :no_linkage
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
