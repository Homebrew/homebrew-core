class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.7.17",
      revision: "7b7d8f4abbc7a35034fcd29cfada52d3d25fcff2"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00686cfc3f32023405d885ad17e9e3ceb74b0ce914c2cef042019a7206a351eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00686cfc3f32023405d885ad17e9e3ceb74b0ce914c2cef042019a7206a351eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00686cfc3f32023405d885ad17e9e3ceb74b0ce914c2cef042019a7206a351eb"
    sha256 cellar: :any_skip_relocation, ventura:        "cb5c05b56c8daa77bb3afb3dff073c72184b11cd323038d17b9778dd5a66a019"
    sha256 cellar: :any_skip_relocation, monterey:       "cb5c05b56c8daa77bb3afb3dff073c72184b11cd323038d17b9778dd5a66a019"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb5c05b56c8daa77bb3afb3dff073c72184b11cd323038d17b9778dd5a66a019"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b6f9220780982dc780e98e9381257b39ada52e3f9295043159d92ac23d46959"
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
