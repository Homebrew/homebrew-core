class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/v0.8.3.tar.gz"
  sha256 "321fcefac0e1e6377e503c036b8c370348ee2df7836c5508133e8b7eeabd5d81"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a5eafa517c7e73c94cebf50895c0b468cf9175e2d05bc80dee4ba60d64f7795"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3be6042e792085f9779ee46b42950d3c97366e534ad0edd73bce1c3c0770f752"
    sha256 cellar: :any_skip_relocation, monterey:       "cf9a670fd472bd47817d718f0c029f0f571f621f6a978b1775c791162ae78f71"
    sha256 cellar: :any_skip_relocation, big_sur:        "36e76ead9fffa9971e3c66f88a3101fbd5bca3bf76690f54d6ae5ac5f3a0170e"
    sha256 cellar: :any_skip_relocation, catalina:       "1dcf3f76356d289bcb28e514c7a755a5648b73f3526a20a3440e2387b8845e02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34e6aa9ac48a099f1caf49a928f3d845fb12ed56935fe25a7614b1a51c5d05e8"
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
