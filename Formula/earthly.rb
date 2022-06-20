class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.6.17.tar.gz"
  sha256 "4a7d0c3b27962fda52ebe77b0a32ab280a5ea4177a3ec3b1b67f2198b0f3ab8f"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3cbc7ce9ca3587bed9cf2e3f8b3e05a067ad4d70d450235da48515d3bb83a0c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b84f870da9bea35c17142aaf7b4b95605f152c024ff8fcbd0d0660534b47898"
    sha256 cellar: :any_skip_relocation, monterey:       "8a9ea705979dc7d24a5806110ba11a957573ee9fbcf66e314e1ef11e959da043"
    sha256 cellar: :any_skip_relocation, big_sur:        "af977b0b76245ddee0a1851be9aa2c8167219d0d660d87131cbc11aafea91fd0"
    sha256 cellar: :any_skip_relocation, catalina:       "3b01cba18dcbb83fc44c0a44eb158b826867b14805cf95addfdfc29c68e1a65a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c6817a572a2a4f9e9ca88b6ece4699bad34f2a20626e6a625a66e80e1935e94"
  end

  depends_on "go" => :build

  def install
    # the earthly_gitsha variable is required by the earthly release script, moving this value it into
    # the ldflags string will break the upstream release process.
    earthly_gitsha = "7e4f1df4c124db1644d51d312b19313217cbe478"

    ldflags = "-X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version} -X main.Version=v#{version} " \
              "-X main.GitSha=#{earthly_gitsha}"
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
