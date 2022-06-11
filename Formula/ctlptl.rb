class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/v0.8.4.tar.gz"
  sha256 "c250ac0b2670669b03060f2276c83971fcbcd20e56e98686b8a2b952dd979fd9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0335893f918ca5aae0840a66c5474b3ef1e446b953a2b9c3e17b59163c630472"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fce0e73815294a0e23a5abefbba8debd0ac57f7807710a77026e8dcd3ca8c2f1"
    sha256 cellar: :any_skip_relocation, monterey:       "af6782cf4bdbe4a82cf95753ffd82eea1a239dd515405d809c8b4baa7bce07d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "c169f0ceff5e20c1cb212e1d4b721119a136a469a2238451b05fd909ade99d4e"
    sha256 cellar: :any_skip_relocation, catalina:       "71f7465c409f0817cf88fb3a5b96e1df202da3efdd8dfb5966c1ce67d5c69e70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "769c3452ca833fcb75b3abba991b5e07d43a47b2c0bc802666c0f0682b0dd846"
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
