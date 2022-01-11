class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/v0.7.0.tar.gz"
  sha256 "10d8a5fcc7f4e88d295e769f283f75aa8ecf9ba9c52d47a723b5b50662b5a9a9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8cbaff0ba12bb5293af0554b1dd128e882675c2ed84e7eb06c09401d205a257"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b71ee1eaa7a76100c7768175af09906c6ac28cb40b78aa3ebcb7749185909ce4"
    sha256 cellar: :any_skip_relocation, monterey:       "ad7b1cd265ce92dfa6be39934a1760741c7e0c8b2e02f2b8db58a99911e2ebc3"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ffe82b921a9c20da238dd8aa330a234d3398fe56cadce68c7bbde8713305bc4"
    sha256 cellar: :any_skip_relocation, catalina:       "012b7627ba7cd4dc8a000050e3f0cafacb2b8a6475e8fc82f2d60f12f0b78548"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16fcf8ca334cff8b87ae6f7b80a61039c42cffa417400a6ba5865a5222243192"
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
