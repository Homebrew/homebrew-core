class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.0.1.tar.gz"
  sha256 "6f496072057cd823416c5358e50ffd93317eb0bd493512890f85c06b4d1765df"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecb1d5bfd1a4bf35d18160a61f807e97308421b0e673c03e8545a6d441f56f84"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39656d3047fe6c4ac4d4298b985ed16e5759a545a0fe95a5ad55291b75154c11"
    sha256 cellar: :any_skip_relocation, monterey:       "d1797466b709bae8a4d8f4ab3006a6517caad9c29f9db08e903652155f420ba6"
    sha256 cellar: :any_skip_relocation, big_sur:        "cbc82a9764395724ca34db7a2a8fddc4bbe4aa0764b8173543acc97c1dee81d9"
    sha256 cellar: :any_skip_relocation, catalina:       "245ad092ac21fcb1e98b44de71f02873439d1fc66a0922b27cc358a1b1f4c0fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2caf503ac8e9ab24e09fee0a5d8eb51c539ab7019de7d8767b32439554676829"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags

    bash_output = Utils.safe_popen_read(bin/"okteto", "completion", "bash")
    (bash_completion/"okteto").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"okteto", "completion", "zsh")
    (zsh_completion/"_okteto").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"okteto", "completion", "fish")
    (fish_completion/"okteto.fish").write fish_output
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin/"okteto init --context test 2>&1", 1)

    assert_match "No contexts are available.",
      shell_output(bin/"okteto context list 2>&1", 1)
  end
end
