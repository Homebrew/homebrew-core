class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.5.7.tar.gz"
  sha256 "7af5932634560339a02160e875ff8086070ab13845b86a024cb363c081b80cbc"
  license "BUSL-1.1"
  head "https://github.com/earthly/earthly.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e2fe31d951bb55ce0620aef79fbcff2f5eeb878b1760676049ef4d3ef0a4311a"
    sha256 cellar: :any_skip_relocation, big_sur:       "a520a5b1387918313025ed0644a6ce71eca81a86cd857208f408ab089bf86d21"
    sha256 cellar: :any_skip_relocation, catalina:      "f96a3975cfd7c9f9a286aeebbfdea9e282e1de88dd37dded04bf4d33b46f2dd8"
    sha256 cellar: :any_skip_relocation, mojave:        "6cf6686ddd864fb35c4db0d2d75867037b6d56755fe950f48f8e5ba5418dcc6d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version} -X main.Version=v#{version} -X" \
              " main.GitSha=a594127c65663967f5fd6b5215e8292ba372c1b1 "
    tags = "dfrunmount dfrunsecurity dfsecrets dfssh dfrunnetwork"
    system "go", "build",
        "-tags", tags,
        "-ldflags", ldflags,
        *std_go_args,
        "./cmd/earthly/main.go"

    bash_output = Utils.safe_popen_read("#{bin}/earthly", "bootstrap", "--source", "bash")
    (bash_completion/"earthly").write bash_output
    zsh_output = Utils.safe_popen_read("#{bin}/earthly", "bootstrap", "--source", "zsh")
    (zsh_completion/"_earthly").write zsh_output
  end

  test do
    (testpath/"build.earthly").write <<~EOS

      default:
      \tRUN echo Homebrew
    EOS

    output = shell_output("#{bin}/earthly --buildkit-host 127.0.0.1 +default 2>&1", 1).strip
    assert_match "Error while dialing invalid address 127.0.0.1", output
  end
end
