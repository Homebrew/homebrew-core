class Earthly < Formula
  desc "Build automation tool for the post-container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.4.4.tar.gz"
  sha256 "1f77dcdabb299999126c29af386e3ac44ced9f8da943b8446110d4e8e0d147b2"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "81afc3261307f8439b6f37d76a4a9f250dbfe2bb82f851675d2a28e930f47d96" => :big_sur
    sha256 "81cf11cf0f5269a2d553d425a0538e273754e9ed9fdce37f3a8ddbb6879ff3b4" => :arm64_big_sur
    sha256 "8b6035a2d78d2923ddda672bef20980232419fb11c4fd1b4497fa4b94f392815" => :catalina
    sha256 "9b747abf15f58696e545b63e78214e6d61d8cb288eefea7ddb0ced416effd234" => :mojave
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version} -X main.Version=v#{version} -X" \
              " main.GitSha=ba26cac4c04a773c5bdf861f36978efa13239468 "
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
