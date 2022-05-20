class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/v0.8.2.tar.gz"
  sha256 "48c07679f9fd04417b15d18a125c75b27e4f32b42d088e96135970af8b31d20d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b78a118ac9fa727f86dbf60d1a0b72a3e269641ee8ef14ad3284f505fe93692"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "586c1f6f8758effbcf478a3554c6e695db6947ea541a4350f05f228c6a6fa91f"
    sha256 cellar: :any_skip_relocation, monterey:       "91b3b902065592edb5cfa5504ef7bf6216c91af6992d3cc817673c0657f3c3f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3b1dc9c1a38b146a5836eeed95ceab7656723d8137bc449a651c28c5eec7374"
    sha256 cellar: :any_skip_relocation, catalina:       "60c65326d04213cd552f6064d9b056232001ee25c9fb27a87821951484f3d2a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06d10ea0e88f20e80c5801a78cf040744e4b0dcd316636350fcefb861eb031cf"
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
