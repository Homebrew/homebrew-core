class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/v0.7.5.tar.gz"
  sha256 "0100e3db2e3899e1d001d76115c2fc407a75c5c5fda03415ebac03f5a023f5d3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8995b3574f92335d381e7fb12feb9e758ce5fc7c58b49c97e8354e6b1dc6ac1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34a39890d867618ee53878b7869ab92e8e638adeca8c6748128e5e487388d846"
    sha256 cellar: :any_skip_relocation, monterey:       "23b36e99a1b1571243cf597a82b9640cb765b3149b5cdb8475a0614df97b8c0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "acf4c813d510a8105ab3fa33cf6255e02576182da58dc81c63ddabefcc2990a7"
    sha256 cellar: :any_skip_relocation, catalina:       "2cb26277edaf8578709df52b6655b8bce62d297028577f500734f0034a1f43e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "292d8ab533dde011338c758f102bcaa4c2be2c7586030ff17ae2ff28b0f5f9a2"
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
