class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.51.tar.gz"
  sha256 "5d7d499f8905f4b48110f881aa797c86876954305ac040004337b355a3236c42"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a65e1a2c8377c4debd416ebd5705fda715e1ba41cd38d8ba09f670bb53fd2328"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a65e1a2c8377c4debd416ebd5705fda715e1ba41cd38d8ba09f670bb53fd2328"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a65e1a2c8377c4debd416ebd5705fda715e1ba41cd38d8ba09f670bb53fd2328"
    sha256 cellar: :any_skip_relocation, sonoma:        "9cffdb20bc0e9951d1758fd0f18bf26855750104ddacb57e8ce60636dac007a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57d964d711ff83dcf080e2fc3ededb0f39dd897ac1227c5f97d678ec0e0c25af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4e7168fb71a4da41222bd433e9598b66ccf2f2206afab877cfa36bf596401b3"
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
