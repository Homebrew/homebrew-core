class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.6.19",
      revision: "d3edff34e19a6e026bbb97d01f6bc44babfa2726"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39612e38a90713b90db051986949c45c101a9787a692a07962cc46f026d83f41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b6cad9dbf5a821ea41d72f183a7462494b6511c6145162a1056743b6e6bd7c5"
    sha256 cellar: :any_skip_relocation, monterey:       "12dde2a3780c5e84bc0e5bb3ba4dd6c54094965a6ef488e38e0daa0d9f948c63"
    sha256 cellar: :any_skip_relocation, big_sur:        "7315d01775db04a90eff987a8623782ada6251bb77952a444c75c84fde18e2e7"
    sha256 cellar: :any_skip_relocation, catalina:       "d1d144271db997e853c53a1e34aa068d6aed3b5e56d837daa44c5cb64efdc464"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a233b003863bbed521dea2108802f8b09305edd5209f79988631e6c885cfc22b"
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
