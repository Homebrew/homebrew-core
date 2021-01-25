class Earthly < Formula
  desc "Build automation tool for the post-container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.4.5.tar.gz"
  sha256 "eacec637d26e91b50dd4573e735a179bbe1c9f049d3add413651e1a69ca834e3"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git"

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
              " main.GitSha=69b9d5e26ddcbef167acfbda4293561cdd67449a "
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
