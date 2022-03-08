class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/v0.7.6.tar.gz"
  sha256 "2555bfa9f5a8a859c12a4e88efa931821af889e7ad46129a2d74739280f72e9c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4bdf867bb9f485ba4f32ed1204d2237e664c65fb57aa2e46cb5335e4b0fd43c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52bb0e35bcda65525a33c922d2e162565b81d15f4f1ad960ef4f30899f7516c6"
    sha256 cellar: :any_skip_relocation, monterey:       "61ee0a7daf80ac30f73d16b4bfdfa84dc14eb00b8cbf60edbdb25aa17db441d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "45955d2a0ff3ac56b2046120d3d2babe907cf392a55072c9dd0b9cce6fd36cdd"
    sha256 cellar: :any_skip_relocation, catalina:       "8cc4c46d19aedb92cd535b6b40c465484e35e008b31085c4391115e64a1f3318"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17aaaff7dc4b93aee71e8a1ad739f8e21b4f0fd05427d91061c3364efe7dc528"
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
