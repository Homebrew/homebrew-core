class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.5.9.tar.gz"
  sha256 "c9dd4d4fa0d22df9c3f589731a11572a30419593eccb4c3336e91e554d7410f8"
  license "BUSL-1.1"
  head "https://github.com/earthly/earthly.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "96c08a5ec465e6c2e72aa08a748e31582f03e6ce579e801f807f035bad826c7e"
    sha256 cellar: :any_skip_relocation, big_sur:       "b3ce125190285a7e77042c0d7bb20b58278713b20cae6443675559cbfdc5caf3"
    sha256 cellar: :any_skip_relocation, catalina:      "50c318813ebaa8eb0d1903469b51acbfb892538c5cdbad6acf438ff2bb18d0b8"
    sha256 cellar: :any_skip_relocation, mojave:        "cd5ad392759f2fca3f2d4066a69d28cd574a60a1f6b4664c86c8ac6d95ca46c6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version} -X main.Version=v#{version} -X" \
              " main.GitSha=1827762e99c23631ca0c14ce236ae904bea8b164 "
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
