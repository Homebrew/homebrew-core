class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.5.6.tar.gz"
  sha256 "666ce1f3235aab343e09a9d977828181453048a8ac589fea888af4a64a768e82"
  license "BUSL-1.1"
  head "https://github.com/earthly/earthly.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e5e6d8fcf6f9479146486325c409e18bdde3f9386fae3ddb79b6a4d98e10cc27"
    sha256 cellar: :any_skip_relocation, big_sur:       "f35410b23b4b7c3b88126342ade4753966c050ae05b51d30ab899fec5d7ed591"
    sha256 cellar: :any_skip_relocation, catalina:      "fa5deb9c4bc3bc3b208ef2218f9d7b378bd9de8090e395b3f6809011db340d18"
    sha256 cellar: :any_skip_relocation, mojave:        "5d01d5883cc6df40c47724eaada70e52889455dfd6e00fbd373fe2fc2338dee3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version} -X main.Version=v#{version} -X" \
              " main.GitSha=42b5954b13f50dcf9683905012ec26dfc222b500 "
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
