class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/v0.7.8.tar.gz"
  sha256 "0377410ed0449fcec9fb3330a98fa88bd007c979657b81edb9013f874b155156"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "214632df0436927cdee856e3bf9cf0f34503486ebbdac129c7312c98e33c859f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98918421624cfad5a9a0108e83131f05383513d8b69e17b2524c8732448072fc"
    sha256 cellar: :any_skip_relocation, monterey:       "a1a6cc457c77263279016aec6a3589421505b84d5bf953448bd7cad3508240dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "df6fb28e0b60d438ef2c9d730ffcba75358cd38dea0f5e44b60c3cf27c4d86c9"
    sha256 cellar: :any_skip_relocation, catalina:       "77fa05dcf8cb80e7b51b7bfd25e0b8f3065f57cd798ffc6106188f3fee720bf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccec6b78d2d36353d8bb5e7789af7e9a667594a768033adc2137fb59c22b8f94"
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
