class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.5.7.tar.gz"
  sha256 "7af5932634560339a02160e875ff8086070ab13845b86a024cb363c081b80cbc"
  license "BUSL-1.1"
  head "https://github.com/earthly/earthly.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4ce971c828e454660b53f94c2f81bd08f83c57bb584be909af4b6e89c8ae107b"
    sha256 cellar: :any_skip_relocation, big_sur:       "38810651d404977929a24c6c492df87f67ce61d6163ad2227d915e37983b1b92"
    sha256 cellar: :any_skip_relocation, catalina:      "eeeed6077f46d5d8a6cf4e00ea21ee67fa6a17adb10e9d12213d581a9db8b8bc"
    sha256 cellar: :any_skip_relocation, mojave:        "62a4985eb4b8704977d88d9a569ee8005e4cd26559901c756f9d0e0266d3e8f8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version} -X main.Version=v#{version} -X" \
              " main.GitSha=a594127c65663967f5fd6b5215e8292ba372c1b1 "
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
