class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.8.16",
      revision: "c48905267920d5599e849e8e043f801c6baab94a"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10fb027ed13b35dd1086731fcd7d2cb12576e3cc5ca4e39b9de0b90320108f7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4c91d647c2b928deac976cdb3f939bcdf71b8d567de1bc80bc2177d4a91bc51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4c91d647c2b928deac976cdb3f939bcdf71b8d567de1bc80bc2177d4a91bc51"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f4c91d647c2b928deac976cdb3f939bcdf71b8d567de1bc80bc2177d4a91bc51"
    sha256 cellar: :any_skip_relocation, sonoma:        "e546a6f2586355f34627aeeebed740d22545a0f55341f461297543f4d9435057"
    sha256 cellar: :any_skip_relocation, ventura:       "e546a6f2586355f34627aeeebed740d22545a0f55341f461297543f4d9435057"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "995dfe4672c78d926733b365c7c6e81f382130eb6db014c855fb9b24eb2c6aa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccb67c3da58fe3524320b08fb9ace8779479ff4afd09a77a2a2dd1ae40fee890"
  end

  # https://github.com/earthly/earthly/commit/9e553bc2905da5fa4f39ad327b80fefed178f70a
  deprecate! date: "2025-06-29", because: :unmaintained

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version}
      -X main.Version=v#{version}
      -X main.GitSha=#{Utils.git_head}
      -X main.BuiltBy=#{tap.user}
    ]
    tags = "dfrunmount dfrunsecurity dfsecrets dfssh dfrunnetwork dfheredoc forceposix"
    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd/earthly"

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
