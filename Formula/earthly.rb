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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d7bcd5669d668b1e4980e08c84650c51b91f611b5544148e59e0319b517053a1"
    sha256 cellar: :any_skip_relocation, big_sur:       "139327d1e63b5a7ca947380ae9583f1c6c5df781fc8a1683345c88252996dd8b"
    sha256 cellar: :any_skip_relocation, catalina:      "6fe33a239812b36737bcb35a603752a601721e1da32422c00b1e8d8cdf74c251"
    sha256 cellar: :any_skip_relocation, mojave:        "bbdfe1d4d6de7d810d46c6f716870dcdb7eca9297df275c68e6e3334dfee9188"
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
