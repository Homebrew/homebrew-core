class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.5.4.tar.gz"
  sha256 "51890c6cd4c269f5414091c0e30ae240871f07aaa39bfc867fef7403e2193cc8"
  license "BUSL-1.1"
  head "https://github.com/earthly/earthly.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "aa035356c27782a07a0163d2178855e878fbb19ea3fe88a7cf3fcb7210e0cdef"
    sha256 cellar: :any_skip_relocation, big_sur:       "47e4935a2d7f15fb56f23ada7d3cbe0d7b6535ae8a435a7ad0ab0fdbe2f61a98"
    sha256 cellar: :any_skip_relocation, catalina:      "8e08ead2e116fdd1045fcad5ffb540e1789de4de7616dd80ab70b3ed621598ee"
    sha256 cellar: :any_skip_relocation, mojave:        "5ade4fab3501ac735435c530b2c094bc7c7f6e411f9b0ca2bb087ecbd057a3d7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version} -X main.Version=v#{version} -X" \
              " main.GitSha=4a161eb9fc46344715a8aeff40e0eeeb1123ea84 "
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
