class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.5.11.tar.gz"
  sha256 "1584495fd8dfa3839f36286fa16bdb611151773033a5e6b936a5df9836c5b06b"
  license "BUSL-1.1"
  head "https://github.com/earthly/earthly.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7cb042be498c5eece87fe21dc4058cb0e120f9de3975c3ec7b6bcfc5ad136f15"
    sha256 cellar: :any_skip_relocation, big_sur:       "a85579fe2ce56105f8325efdb699be34885623c61058d104904dbcee10b9cb0b"
    sha256 cellar: :any_skip_relocation, catalina:      "f7d7f6e751034d9315c8466e128b94ecb448d995d7ed3aaa1f5537a19c6d9281"
    sha256 cellar: :any_skip_relocation, mojave:        "4c984626fc13facd2b1654b414754812ef478360911f28a4f3a4d5c4ec3cb648"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version} -X main.Version=v#{version} " \
              "-X main.GitSha=4441aa72487b448d1a3e94cb0ae6afc1ad02ce96 "
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
