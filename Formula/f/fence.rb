class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.60.tar.gz"
  sha256 "aa032b5b05a22561aab817eeca9313ab4adc25265cbce5aec5bb95c0ab55876a"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6ef696522b9ac0f91016e37a147043fc1238bfe01ba6c85dd167aff6586072f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6ef696522b9ac0f91016e37a147043fc1238bfe01ba6c85dd167aff6586072f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6ef696522b9ac0f91016e37a147043fc1238bfe01ba6c85dd167aff6586072f"
    sha256 cellar: :any_skip_relocation, sonoma:        "52d9c47369f415fbf3cde95206c52ae7fcdcdf7c49ac99f60eaf1ba1548d35e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f75e6ffa50aa9028f3ac9f8790cbc1b0b913f031ace180c717d3085bb23d9ecd"
    sha256 cellar: :any,                 x86_64_linux:  "ad133b54a2d0122b1003955667a5056f9da65ab02a57e9ca199ad89f08a6814d"
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
