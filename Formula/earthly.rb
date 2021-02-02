class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.5.0.tar.gz"
  sha256 "4cbaa040f76ebcfc3954596a0ce5f23fcafbc0c61f8e3c16e2a8ff6ed358bead"
  license "BUSL-1.1"
  head "https://github.com/earthly/earthly.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "25a294e32cf94e1e118d8682963d95562aee33c0d9aac221d4c8f8c6e9aba2f6" => :big_sur
    sha256 "942535e18d93957ef5e70ebfd31ff69afc5b2d26aec8b10ca510b3ee94e3062b" => :arm64_big_sur
    sha256 "1e729e56bc486688d5ed10aa5c77b6440b3de7f03793a58b0860ef06428cf650" => :catalina
    sha256 "568b3fdf96db335f200feac9c3ed3458f7866490494a9ea1dda8c806aafc2a0b" => :mojave
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version} -X main.Version=v#{version} -X" \
              " main.GitSha=857fb8ab003e642dfcd9217c56c6d06ce3e5d137 "
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
