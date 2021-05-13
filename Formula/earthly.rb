class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.5.13.tar.gz"
  sha256 "a2f03a23320bb98e1417d5a25a1ae5050b35f42d782e354eaedaf50fbd62abe8"
  license "BUSL-1.1"
  head "https://github.com/earthly/earthly.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dd8bb6b5fe4f5be9fcc0e72826cb76e8d728345d3d220fd2b161a972f3254313"
    sha256 cellar: :any_skip_relocation, big_sur:       "df25483723b955a9ca409f4604194eb3fd5885c42230721d5d591f08adc98475"
    sha256 cellar: :any_skip_relocation, catalina:      "26667d60d9ed1d3987f7ced81a33ebf988ad34bea9d6d68e74371c206d8dd820"
    sha256 cellar: :any_skip_relocation, mojave:        "9a897c073fe7448f3beaa3cb70622cf425895a0c3256b79a1f44d3bfd35b32e6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version} -X main.Version=v#{version} " \
              "-X main.GitSha=a7f082f8fade1badbee0a221c9a9da2317449e4c "
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

    output = shell_output("#{bin}/earthly --buildkit-host 127.0.0.1 +default 2>&1", 6).strip
    assert_match "buildkitd failed to start", output
  end
end
