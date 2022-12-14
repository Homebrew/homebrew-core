class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.10.2.tar.gz"
  sha256 "35f658d0855f0c0ec3fb8dc21123dc69b79faa3aaa4796e9ccf82f7a8125b81f"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a377990f6ca83bc7ed16bfd2d0ba005507e8f804a3e3390c3754102f82ea7988"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3cd90eb4ee91d77602d0a151212ad58f03e1755f09d120464766717ffb27d721"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56d708b00e4fd869695c1b17f6ee6468a214f88d2b6e68addf298b2e34a8709c"
    sha256 cellar: :any_skip_relocation, ventura:        "38f047de29d153648833696dadba20325921faf7a6cc27aadd3ba5fd688882be"
    sha256 cellar: :any_skip_relocation, monterey:       "f9f79ad4b571e6a480a06432ea868a0ba7ea4397941b2dce0006cad35033eefd"
    sha256 cellar: :any_skip_relocation, big_sur:        "70474f2722d9b36670e82d261f05bc5ee1f98374711b191c7d920cb0a1719904"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f17fff347dd604c240466b35333ef54d32cd8bba14e334be961a95b11f9400c6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags

    generate_completions_from_executable(bin/"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin/"okteto init --context test 2>&1", 1)

    assert_match "Your context is not set",
      shell_output(bin/"okteto context list 2>&1", 1)
  end
end
