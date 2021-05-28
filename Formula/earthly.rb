class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.5.15.tar.gz"
  sha256 "11a0c6c6efd6c6ff56cbb4d997d04412d811178fd7acb3610c0296eab035ca83"
  license "BUSL-1.1"
  head "https://github.com/earthly/earthly.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bde1ba87bb679d587cc1c51c59664909a1ac44baf4e13b0830d6fcd11de7b6c4"
    sha256 cellar: :any_skip_relocation, big_sur:       "2fb167bcef376518deb3ecb7433737f863eedfe0d66d4632ba4c67fca9bbd1f5"
    sha256 cellar: :any_skip_relocation, catalina:      "1b7ac2dbebfcf4b1e7e12206d08b1ab0c8beff9a06e46b7cb35a1471d694da25"
    sha256 cellar: :any_skip_relocation, mojave:        "83f81697de31e87a2b667f962448b1225f808e67b68ac3f8760b98f88180022b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version} -X main.Version=v#{version} " \
              "-X main.GitSha=78717c4363e0893e0a5d55f81dd2e069d7b6ec65 "
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
