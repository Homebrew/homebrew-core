class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.61.tar.gz"
  sha256 "4df2107171de9c420252c5fc9876887238b49d46fa474fdc1e15522b4036a949"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4e75b67d9f1a9a06fe4ca2d4694aed800f495c7337a5b1b6f06922721fa883f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4e75b67d9f1a9a06fe4ca2d4694aed800f495c7337a5b1b6f06922721fa883f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4e75b67d9f1a9a06fe4ca2d4694aed800f495c7337a5b1b6f06922721fa883f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e13841773e8d0410285c91b450e186289ce7cf6b17cc6d840b4c8039e8fc49d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90cd301687207fa0ba1fd84c94b476979ac8c0090605549e5459db85e85a8e4c"
    sha256 cellar: :any,                 x86_64_linux:  "50db923de0c5993123879d8f487111080ae83e10bf112f6ee937f85dd238efcb"
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
