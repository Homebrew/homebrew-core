class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/v0.7.3.tar.gz"
  sha256 "150eb98337631168218e08819582e92adfed1f86021858a9162ca9bcaa82c9dd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aeec10e7cfbd2aff1101c75a4950e140c0fabfa46f4f05e89f9b5e4cc55d99fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c23da27d4a7e8c6a8d57e802e6e54953f06d798d93a1a58ce275340b5ab67862"
    sha256 cellar: :any_skip_relocation, monterey:       "6e4b0af8bb7cc5cbbf74e05d55b89bfc36f875aa72dc40f7b6669e695500a918"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9b7d61ffee2523c577cf8e576846084680b01521e6afbb936eb58a3d110df8b"
    sha256 cellar: :any_skip_relocation, catalina:       "fce9aa48804cabec6712b00573d6b867e4701f4add9b0cbb3ee7508136efaf90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a6bdfd2f519435f2151b1c24d88238e48b9ff4db568111ece4f9ea9eed0d423"
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
