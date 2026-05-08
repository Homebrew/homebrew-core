class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.57.tar.gz"
  sha256 "cc29d80141c920eb628f8fca900839f698deea3ce93c74bdef261da21c9d1667"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34e17be93611af33d708b1487c51bf286b8ce60cadefb31a15cb843163035c12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34e17be93611af33d708b1487c51bf286b8ce60cadefb31a15cb843163035c12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34e17be93611af33d708b1487c51bf286b8ce60cadefb31a15cb843163035c12"
    sha256 cellar: :any_skip_relocation, sonoma:        "42ffa4b27c3717f952aa776ee643d31fc49b1bd1fc9fa88ce9f60ef3288c7deb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9f217017c3c9780af286369d1a738b8abc4a10b16ce86e62260620f1421730a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "190bc2a8a04dacbba4543c52900f7c1a6507a8c6e1868396d9b7e001bdff1c69"
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
