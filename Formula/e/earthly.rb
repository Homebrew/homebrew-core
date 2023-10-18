class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.7.20",
      revision: "9600f376026c11d23eb43fc68ad716d6ae4cca2e"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "11ebbf4b94ea1c893643fc6d35357b7aad69a63bfa30fe5aaa1ab4a3b14df0e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11ebbf4b94ea1c893643fc6d35357b7aad69a63bfa30fe5aaa1ab4a3b14df0e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11ebbf4b94ea1c893643fc6d35357b7aad69a63bfa30fe5aaa1ab4a3b14df0e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a85b11fbcb8bc535fe88fbad81ebabf96e78c96d4712d4bcee5d33607245171"
    sha256 cellar: :any_skip_relocation, ventura:        "3a85b11fbcb8bc535fe88fbad81ebabf96e78c96d4712d4bcee5d33607245171"
    sha256 cellar: :any_skip_relocation, monterey:       "3a85b11fbcb8bc535fe88fbad81ebabf96e78c96d4712d4bcee5d33607245171"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44f111847b5b977a49dc44588ab720ceeb64c3d6714d3a95616f6f2bc477ae5d"
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
