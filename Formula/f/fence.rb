class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/fencesandbox/fence"
  url "https://github.com/fencesandbox/fence/archive/refs/tags/v0.1.63.tar.gz"
  sha256 "72e7b544b74da03bb43aefbc1511792245a053f3d01b18b315c3a74f682fc37e"
  license "Apache-2.0"
  head "https://github.com/fencesandbox/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bca479250b040f746351f6b050130700820e02aee6c2b1f67d54e4c2ddf48960"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bca479250b040f746351f6b050130700820e02aee6c2b1f67d54e4c2ddf48960"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bca479250b040f746351f6b050130700820e02aee6c2b1f67d54e4c2ddf48960"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0e6bb918c2fa1bcf30abf83ee7a6b3a42da1e70b03a81ae642b62d250d2b6d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8cfd8fd3cc668a62215d162165c905d20a7ab2e6156b7fcfdd671d04f0f59d04"
    sha256 cellar: :any,                 x86_64_linux:  "532cf3a37685d495ca1d5e4127949ad74204e4c85d0c8b8c2fec74a86fae5343"
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
