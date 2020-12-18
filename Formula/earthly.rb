class Earthly < Formula
  desc "Build automation tool for the post-container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.4.1.tar.gz"
  sha256 "29e0581b9432e8b34f829921158a3136053a4201b7be493b5812f3d170bf02f1"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1ba9f9a682a1b479a6b8d89ab3fb3a1bf61340a2917e93dee6015edaf5114af5" => :big_sur
    sha256 "f5000c0c85b4de73abbe2dab49c534b30e521cbb9937f3fbd446d9828cf3cb05" => :catalina
    sha256 "4eaf9ee58decd8cd3b09c558c53c0d6c4f3688d2a67df4724db482c9dd64ce5a" => :mojave
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version} -X main.Version=v#{version} -X" \
              " main.GitSha=9b79e2f1e4f5dc4220c8a34372d9774dfe4d4d5b "
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
