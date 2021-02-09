class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.5.1.tar.gz"
  sha256 "19bec5a21daa1ec34dc0079d6220b601389b6aa94fafd4eb1fecde12b023eb4b"
  license "BUSL-1.1"
  head "https://github.com/earthly/earthly.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "55b3b07e2ad3ca842879de910f8926f005031a50f3113f8049e66f88af2e6989"
    sha256 cellar: :any_skip_relocation, big_sur:       "5c4ee0d5f0645236dcd99fbf534b09d3b460cc9c1ad6f4b03acefe31e519d64a"
    sha256 cellar: :any_skip_relocation, catalina:      "62bf4d7118fedc4ce0f0b63695272aa4d341622fda6e2812255b3041f05d66e0"
    sha256 cellar: :any_skip_relocation, mojave:        "3b895a61836ee9b38ad2d23d6f663b1815ae2bc59a3a0bd6b56a1afd98d911c5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version} -X main.Version=v#{version} -X" \
              " main.GitSha=243626a40e831bb8f3678860f4763f98e52cd4eb "
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
