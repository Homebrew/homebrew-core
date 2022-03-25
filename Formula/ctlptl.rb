class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/v0.7.7.tar.gz"
  sha256 "84a1b5bb106caaa475c97ce7e6aacedad8e1162792b5fc0b5027eac9ceccc8c9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "192495538b3e97bcacfd5ff30f19e83d7865e407f2cbcb1565202c3aeee7b24b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f22f876527dec76238f7b410d4d598a0eebce83579affffefb34cf17cd9e82e8"
    sha256 cellar: :any_skip_relocation, monterey:       "1e0ca7b06fd7e361873d8645e164707fcee3f9ed93dcbe92fe5e0e69d1c2d8c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "d552bc2c5d2bb4b64fab4f09fa5cb2bbb88b9ce9aa526d70ab58a71fb8577141"
    sha256 cellar: :any_skip_relocation, catalina:       "a2818b782d04d07c5130d61b36f0c03669a1f66a16874612b8085173fee9eab2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bcfa5af9cfec59b31195b63091f85c3af81bd33727f3ed560bfcd343a834511"
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
