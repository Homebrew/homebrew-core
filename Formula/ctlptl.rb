class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/v0.7.7.tar.gz"
  sha256 "84a1b5bb106caaa475c97ce7e6aacedad8e1162792b5fc0b5027eac9ceccc8c9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1632a7ace0d8532f532c7a0c5f996d9400e3a6acde05eb4ddf90c61ca8df0c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3141a26deacd417312cd220129edfd6dbc1ffa60b01607c0a445e23f69b56929"
    sha256 cellar: :any_skip_relocation, monterey:       "6cd1dc426c276cca5cb5d1e4df87255a25c939c5004f1bb31477d418273c9d55"
    sha256 cellar: :any_skip_relocation, big_sur:        "68e7ed71c86aa921b99076b8c6539c3e6fc37c299c003720f1cfd1aabc2685d0"
    sha256 cellar: :any_skip_relocation, catalina:       "092f6145b0283773d1db7e9af9d1afe76f44cf13d979c9a0dffd29a2ae8cb4ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49d96046f6f66bdc2e25bf21a83e077af7da4f1f78e890c573c3a1d6a417183f"
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
