class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.3.0.tar.gz"
  sha256 "eb294c25920ec664163e982a1b71c101bda1b7940c71aa455c8eb0f5ac013181"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad2fb1e025b5f25ae1eb938ad23ad61bfcb6a32c35f0d7b310f05f5098074463"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f3ac7fd2a28dd23a5b5725de97cb8331ff22d3840f2483f44e192dd9f5e2585"
    sha256 cellar: :any_skip_relocation, monterey:       "f3bc81d4161f86c1fdfb7d6f7bff95b1c698e3686e7bc0227f8e4f5a4ad35f78"
    sha256 cellar: :any_skip_relocation, big_sur:        "0926387638e1bc5f2efaebbd7f22b095c9290ce425f6fcea15cad6125d6a08db"
    sha256 cellar: :any_skip_relocation, catalina:       "d5cb52fe5475a9e5ba79908c57e8a2a718e05e6fa0bfab079e758452bf284e72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77fac7d0abcc7d5e624074737b51c112b462ae4e82e80cdf60f97c068378b717"
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
