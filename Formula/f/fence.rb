class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/fencesandbox/fence"
  url "https://github.com/fencesandbox/fence/archive/refs/tags/v0.1.62.tar.gz"
  sha256 "fa018f71bb8361780e9c9d17e82352e2503926a7b501ef0e8c6ab4c844dd82b9"
  license "Apache-2.0"
  head "https://github.com/fencesandbox/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9e15e5d2f1c2f62c27de54b4823fd3b9cb9e71e3ad9196ad8c4efb4ed5cbb8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9e15e5d2f1c2f62c27de54b4823fd3b9cb9e71e3ad9196ad8c4efb4ed5cbb8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9e15e5d2f1c2f62c27de54b4823fd3b9cb9e71e3ad9196ad8c4efb4ed5cbb8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1d1842abc75db7e1d3025605f36c0c014cfce66135b9ebd71dfd15fce9f4d32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f023c089c8830f6cf09bed42b34c529b452d7d7e456abc369883126cd6254b08"
    sha256 cellar: :any,                 x86_64_linux:  "0d038ad6d2ce322e5ff6877f74de90be9641d98b10d54393afa22d3c9602572e"
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
