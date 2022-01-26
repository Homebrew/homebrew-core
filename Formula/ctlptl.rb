class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/v0.7.4.tar.gz"
  sha256 "8919ca954534590b3d2119bad6fddf35aac981b080640bbb5de9a53536974779"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42d5a4f6e3cf06ec46db79031098bec13c94bd6cea84d90299502cba90e66ed8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1a76d3f2c86529f543cf0ef9bbb0edc3f8ad6d1aa6e5c04d3568ecf0d802171"
    sha256 cellar: :any_skip_relocation, monterey:       "e9dcb399d6d22f30fe11315ec41c5f60ad5e0465ea2c4d7b527086bd25e6e035"
    sha256 cellar: :any_skip_relocation, big_sur:        "f966d377af880b54a624553c247af12ed020d8bc9c981067bbe9792b130715ce"
    sha256 cellar: :any_skip_relocation, catalina:       "0679af04644e5e66b1ba55d57c4f9ad73c7a284d59c55f1f2e6abe54292f8585"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c6579e97c21957bce6fcb109a66de92a56925cc934d87455c9101d9d355ccab"
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
