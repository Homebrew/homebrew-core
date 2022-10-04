class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.6.25",
      revision: "b9a16aa25c15201998ddc7781efca5934c1f7660"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27d71a1f6b96e9a239fbf180f17e11b640c87b1787c7b4541230cbcd8851da0e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d47248067d23268f1f4297235309d6dbefb7c34b30b2a32d4c84a6bee477f782"
    sha256 cellar: :any_skip_relocation, monterey:       "25ff400bf6f1f36d98264166f167342e57c9761303523838451fefad0786410f"
    sha256 cellar: :any_skip_relocation, big_sur:        "87c63308ddc9151a2e486f8cc4a71db1201548f1ebb3d16a52060d5106cfbf30"
    sha256 cellar: :any_skip_relocation, catalina:       "b70f49514c7eb340dd75a0bc179b93fae7c5c58ff0eaca125680989b8c1d9d0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a7c768a2e664222a1fe045dab37dfeb212fcfc04923d074fb19c3828ea591c6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version}
      -X main.Version=v#{version}
      -X main.GitSha=#{Utils.git_head}
      -X main.BuiltBy=homebrew
    ]
    tags = "dfrunmount dfrunsecurity dfsecrets dfssh dfrunnetwork"
    system "go", "build", "-tags", tags, *std_go_args(ldflags: ldflags), "./cmd/earthly"

    generate_completions_from_executable(bin/"earthly", "bootstrap", "--source", shells: [:bash, :zsh])
  end

  test do
    # earthly requires docker to run; therefore doing a complete end-to-end test here is not
    # possible; however the "earthly ls" command is able to run without docker.
    (testpath/"Earthfile").write <<~EOS
      VERSION 0.6
      mytesttarget:
      \tRUN echo Homebrew
    EOS
    output = shell_output("#{bin}/earthly ls")
    assert_match "+mytesttarget", output
  end
end
