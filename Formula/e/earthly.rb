class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.7.15",
      revision: "ae8f65528ad37a278985de2e234deb42b91e308f"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59bbc048e590978ba971fb54df53d6d7b4a3fd3520894db752ebd29e724c2fea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59bbc048e590978ba971fb54df53d6d7b4a3fd3520894db752ebd29e724c2fea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59bbc048e590978ba971fb54df53d6d7b4a3fd3520894db752ebd29e724c2fea"
    sha256 cellar: :any_skip_relocation, ventura:        "0a4e9a65e2d1726804f5e8de746e43178dd5f5de3dfd36f2168f001f45a48d2a"
    sha256 cellar: :any_skip_relocation, monterey:       "0a4e9a65e2d1726804f5e8de746e43178dd5f5de3dfd36f2168f001f45a48d2a"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a4e9a65e2d1726804f5e8de746e43178dd5f5de3dfd36f2168f001f45a48d2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9de50ee2821aff086b828b1462cb5c22364bd67d650b0b77b8851c48272d363b"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version}
      -X main.Version=v#{version}
      -X main.GitSha=#{Utils.git_head}
      -X main.BuiltBy=homebrew
    ]
    tags = "dfrunmount dfrunsecurity dfsecrets dfssh dfrunnetwork dfheredoc forceposix"
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
