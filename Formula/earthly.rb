class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.5.2.tar.gz"
  sha256 "f95f9b74f27cc38ba105274f2a070dd5c21ba3d840d8245b2bf264041b53e8ae"
  license "BUSL-1.1"
  head "https://github.com/earthly/earthly.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "db98a60a23b2efe39d0a434712cf751ffa140b1f02724bad373dc5bb8c384b96"
    sha256 cellar: :any_skip_relocation, big_sur:       "6646599b0a6505a6c91e5b180ccb927f75a59bc1ea11470e13e3432060a5ecd6"
    sha256 cellar: :any_skip_relocation, catalina:      "9711247f2029c5ed3ff4c69c0daa48ba0e30d2e2ae71e9fbf81a4346c48859c7"
    sha256 cellar: :any_skip_relocation, mojave:        "8b2f3b9aeba58b90ec60dd58080428def3581df1a3af5722e5774e842203cd21"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version} -X main.Version=v#{version} -X" \
              " main.GitSha=10e367052402ceb2a8afe0cd292a2fc8db7042da "
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
