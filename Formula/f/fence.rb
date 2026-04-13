class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.46.tar.gz"
  sha256 "8f49c165a86418841a2ed7d6787997d60e7b2f3790e6b03ed7b3fe39470dac3d"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a2a7101e6a60e2c3e6992f01462ab7111917339e5192ac9ea8d5f76920852c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a2a7101e6a60e2c3e6992f01462ab7111917339e5192ac9ea8d5f76920852c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a2a7101e6a60e2c3e6992f01462ab7111917339e5192ac9ea8d5f76920852c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "369b0a3125055b8a464c6ec1709854da07308d53e45450c92a658dab8d7c9506"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f40a0d7dd729d5837335a569e3449a455d130625dedd52261fa7b451a4192a62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbc13cb8f47676abcadeae6c45eec01be38322f15597d519930d01a4d84a89bb"
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
