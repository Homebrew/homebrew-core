class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/refs/tags/v0.8.28.tar.gz"
  sha256 "7f973f10e7bf634c7fa0129619202e64f1ef2bdc5483ff1499270f782836520c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ce02b5583c831cd7dbe353a68fa06fe02cfb520dbfb92fb4cc1e484ea2c7eee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b6f85fddf3f6cc1306589ddfd31ef582add15b7edb0ed63b6044e890da290da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43a29776f2809e1c5f6552a1f1ff6b36fd4d311d58a0e71e3242517ba2e7c3fe"
    sha256 cellar: :any_skip_relocation, sonoma:         "e608375e6bd49362a8a20d45545633ee9d5483e9463a213604a55e09e8fb5872"
    sha256 cellar: :any_skip_relocation, ventura:        "fa573de88462c1527adf534f8d8fa0c27bbe8e36cc187f2d78202a0e87cb4bf8"
    sha256 cellar: :any_skip_relocation, monterey:       "edbb04daea5072a337423924a74507652cacb6befb5952b7d67ede5f64e93a68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38934cbf12e3ad0b0504c3814172728633384105106babd90ccca9c848921553"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/ctlptl"

    generate_completions_from_executable(bin/"ctlptl", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/ctlptl version")
    assert_equal "", shell_output("#{bin}/ctlptl get")
    assert_match "not found", shell_output("#{bin}/ctlptl delete cluster nonexistent 2>&1", 1)
  end
end
