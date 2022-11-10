class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.6.29",
      revision: "1e00ed63cd506d1b017cb761a2b8d63b66dc2f23"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ca2bbf6453fe7539eba3f1ef4b63102a85ca6c7b319b9ccc082e339e8f25879"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19c6f56c993bbcf924828cf3009d6d09b4a74139df5f7c11f85fe6fcddcae5e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6974b1524d7b05795563a5c95dce3e1967d30ff778b397bb02afade8fb2b29fa"
    sha256 cellar: :any_skip_relocation, monterey:       "b07bbed00f8f8183f42b9964ee3d1dba0e90ecdaf59afe5a9e3182ff5676f6cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "7527994aff5dba66b84d1121b34c0e0c9df25e27eda6c5ace38104c640ac9429"
    sha256 cellar: :any_skip_relocation, catalina:       "0172bfa3fa4b8692ec39367f53d0baf0589f77775efb229240e0e5199ccd53ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e01a70dde0ef64e83dc8d2ae49bb6650f5eab1e894e99a94585dcf5cbf995935"
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
