class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.6.15.tar.gz"
  sha256 "b9c9c1ea4be45b9dc13b465b8282b2085e43c5ad4f1d5ddc842ca13949482184"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6ced4b644da7733596ddb225d4d07dddcdf3cea9975a1dcdce724e65093142fb"
    sha256 cellar: :any_skip_relocation, big_sur:       "45b1406d85fbc167590873e727dd63624ed17bceadc289bb4c6c7f8e8a669317"
    sha256 cellar: :any_skip_relocation, catalina:      "16c593502fd9a7270edab13a2ed8c9ca44486eb90bc97dceef99ec8c092ddadf"
    sha256 cellar: :any_skip_relocation, mojave:        "a9a09599ccebca0c987ea802cfc861097055ab2662db97c417bfeb83756fdb90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78f6b33643db61f1944ceaf27d27ad001f8ba7a865b358a040cf1374fd618a96"
  end

  depends_on "go" => :build

  def install
    # the earthly_gitsha variable is required by the earthly release script, moving this value it into
    # the ldflags string will break the upstream release process.
    earthly_gitsha = "05fc449487ad0c8a1721b4fbfc527eb9870dfcfd"

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
