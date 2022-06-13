class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/v0.8.4.tar.gz"
  sha256 "c250ac0b2670669b03060f2276c83971fcbcd20e56e98686b8a2b952dd979fd9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b629610212ca4ebc69eed49fcc55707ef49b9f6aa5a252f21c9a6ae7ee0e669"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58d08fd6f5a31892aed268b2f3c96bd92d313509c67979d98bd97bf220bc9189"
    sha256 cellar: :any_skip_relocation, monterey:       "55429d907fde743595bad1b1364d2790290defa6de4f71939875d1a8bc3b2d36"
    sha256 cellar: :any_skip_relocation, big_sur:        "a230876404058e8d88e4a9b4e832046e190c9ce9f984e5792231cdbc9aa984d8"
    sha256 cellar: :any_skip_relocation, catalina:       "b28f095db65062cafb90a3d861635ae418d3609df5e9db815e96d609bd10592b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b0a5b50997ffa838e6de7a9d395f3dc6bfbcde6f7fe577a4a0ad2d763632b53"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/ctlptl"

    # Install bash completion
    output = Utils.safe_popen_read(bin/"ctlptl", "completion", "bash")
    (bash_completion/"ctlptl").write output

    # Install zsh completion
    output = Utils.safe_popen_read(bin/"ctlptl", "completion", "zsh")
    (zsh_completion/"_ctlptl").write output

    # Install fish completion
    output = Utils.safe_popen_read(bin/"ctlptl", "completion", "fish")
    (fish_completion/"ctlptl.fish").write output
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/ctlptl version")
    assert_equal "", shell_output("#{bin}/ctlptl get")
    assert_match "not found", shell_output("#{bin}/ctlptl delete cluster nonexistent 2>&1", 1)
  end
end
