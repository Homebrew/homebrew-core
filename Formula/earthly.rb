class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.5.16.tar.gz"
  sha256 "b3b265a1c5a0e64b966397f43420a8fce9194ea345d2c425c8cc22900a8f6a62"
  license "BUSL-1.1"
  head "https://github.com/earthly/earthly.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "090557754a94267a58f6848fea2708222799424c5bbc979fd057cb5b15b15230"
    sha256 cellar: :any_skip_relocation, big_sur:       "d1993327b158309867f4df7df6355a2fcc181dd1c9a3841f76c15c37ffcf4724"
    sha256 cellar: :any_skip_relocation, catalina:      "dbf4bf920851d79f6e029489b2397763be1cc52575dac02cdd78467c8ab7cf68"
    sha256 cellar: :any_skip_relocation, mojave:        "2a330efdfeee30934f36aa5ad90dc66ba941b4fb9237a46112fcec4d1aca1711"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version} -X main.Version=v#{version} " \
              "-X main.GitSha=e8b0e570c5d843afad953ab8caab118d34adc229 "
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
