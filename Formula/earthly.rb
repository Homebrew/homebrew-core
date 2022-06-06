class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.6.15.tar.gz"
  sha256 "b9c9c1ea4be45b9dc13b465b8282b2085e43c5ad4f1d5ddc842ca13949482184"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa732b3294f66db383bc8f6d7a33a23543f8488679881d369a2656451db6094c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26803f7f2f0100ef18baf1c5b346dbba297a475c27ff523444a342e60ef2cee4"
    sha256 cellar: :any_skip_relocation, monterey:       "6e4a11a9174e4123f96297076367e194e2718b78d327a318a0adf6c5c22b2f05"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c1aecb5821538e5a45237f756f5c0dc91ed4e287aff4f5dd047da095763e3d7"
    sha256 cellar: :any_skip_relocation, catalina:       "f56636b9fa8335719f6db70af480351df273a036b649a30377431bae6e3e7995"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ac98c87feba61de05059aa03686bd493ea5f5f9b45a9194cddd20fe8b5bd3b4"
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
