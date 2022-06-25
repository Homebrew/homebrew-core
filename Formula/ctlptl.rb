class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/v0.8.5.tar.gz"
  sha256 "54807ab4a23600199c1c624ed630c7bda536d5ef898e272dc91ebbfa17f177c1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c447abf3f8ec6a4a09015303cf58bc4df666ab8d153a61e08cb4515764bc6f2b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a02c2872916cdeb06a247227fc29091e136bf416c170d2a04721bc1eccb7e4c6"
    sha256 cellar: :any_skip_relocation, monterey:       "b3b1ab011946cb92e754034a5779d40811aa36094d913e40fe8973b64d8c32b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "6af149d0876f10903655d100456c72ccbde285a3512fc22d00f26c3e8d8d38bc"
    sha256 cellar: :any_skip_relocation, catalina:       "9dc766bd024470475a82890fe5bb051074d3244896f628a398d940c60d9c2599"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "303b27ba088fc2e3e1d088a78cdbd91e2e9c7afb7815da8ff942c1a1bdc1cb70"
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
