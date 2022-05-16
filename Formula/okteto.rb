class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.3.0.tar.gz"
  sha256 "eb294c25920ec664163e982a1b71c101bda1b7940c71aa455c8eb0f5ac013181"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "794ed0b7eee39b0eec18f9b044f99918e1c8e6964d247fc4880b95fc5be60481"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "205a758f0b26105c9f3bc1bd0d88d4d9736067245741a93070bd8df1bed00c6f"
    sha256 cellar: :any_skip_relocation, monterey:       "65eef13b0380fd01caaaaf0e8342f0e34b8983b43185fad0d5048d3988c72b6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "64cc32e34c11af7b18b36b8459e79473becb42b3abbeba4816bb2ac44cd81210"
    sha256 cellar: :any_skip_relocation, catalina:       "caa6d249e4cf7cafccc175d9c1814d2548263a114525503206aecc826de2ad0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb5ef82facd489cc8dc5a53ba26a900a7fb2b4dd18ec2f62746e913f8437bca5"
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
