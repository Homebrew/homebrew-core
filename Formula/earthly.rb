class Earthly < Formula
  desc "Build automation tool for the post-container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.3.19.tar.gz"
  sha256 "4ab1b3cba1e59717ea16a6a5f4882e9ab7987b5a10b97aeb0c15795de63ad98d"
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
    ldflags = "-X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version} -X main.Version=v#{version} " \
              "-X main.GitSha=15320ce66408df05cfa6918a5ad69bd4d5b4cb0f "
    tags = "dfrunmount dfrunsecurity dfsecrets dfssh dfrunnetwork"
    system "go", "build",
        "-tags", tags,
        "-ldflags", ldflags,
        *std_go_args,
        "-o", bin/"earthly",
        "./cmd/earth/main.go"
    bin.install_symlink "earthly" => "earth"
    bash_output = Utils.safe_popen_read("#{bin}/earthly", "bootstrap", "--source", "bash")
    (bash_completion/"earth").write bash_output
    zsh_output = Utils.safe_popen_read("#{bin}/earthly", "bootstrap", "--source", "zsh")
    (zsh_completion/"_earth").write zsh_output
  end

  test do
    (testpath/"build.earth").write <<~EOS

      default:
      \tRUN echo Homebrew
    EOS

    output = shell_output("#{bin}/earthly --buildkit-host 127.0.0.1 +default 2>&1", 1).strip
    assert_match "Error while dialing invalid address 127.0.0.1", output
  end
end
