class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/v0.8.1.tar.gz"
  sha256 "d0c9e42161f9579a864f23e7059eef9ab53934c891f2d21d7deff52a816e2362"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3afb7f5b1779638e21a43f53863f7f693bb0fc3c48d3f8ff8ff6a22bba1d47bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "80fe60f75ec24b2cf22184acd70d6bee67ef1dfddc8dce7dcf67d8b644946bae"
    sha256 cellar: :any_skip_relocation, monterey:       "2397132ecf8a006db8343ad1f741596fc267de6a813c9a2709224877ee1f47ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "8146af8ebc279ab2ea45e5cad735680058f8d189855d838b5cfd5ac3c4874edd"
    sha256 cellar: :any_skip_relocation, catalina:       "e88af3af12e4a6d391b16cce83590fb569291e4c34956b4f6a8691f56279897f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba5f9fac554a7d4af9c27a215adaa745d8a8d3a5e202e814e9fa11342ea83ade"
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
