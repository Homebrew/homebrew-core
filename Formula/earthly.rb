class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.6.21",
      revision: "a24b203e9770d822c9161c7cafd83ba52b6db745"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee359a65e3c55357d83ff1c82213150a7fe23283520555c4b76fe0354599a62f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce403f2b0a41da23a37e8b281e3999833d7d997420f592e5ec60c641e1cd8617"
    sha256 cellar: :any_skip_relocation, monterey:       "fd5a084d77d417b64b17c845ae5d86c84103e3f6a22090a4b9197c6e81da913b"
    sha256 cellar: :any_skip_relocation, big_sur:        "f434005206785beaa701e33e39c7aeceee62aaaaf0ca3b43b8c2b7e6e88cacc7"
    sha256 cellar: :any_skip_relocation, catalina:       "d5f3d4735bfacf29df99d863a102ece95f9b2ffdd006aa1802959d9e7b5ca9e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f8107dc53fda28963c44f8be3241e8448a1e4a60e3c46d119c82da5a83f5f69"
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
