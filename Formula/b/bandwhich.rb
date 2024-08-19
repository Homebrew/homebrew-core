class Bandwhich < Formula
  desc "Terminal bandwidth utilization tool"
  homepage "https://github.com/imsnif/bandwhich"
  url "https://github.com/imsnif/bandwhich/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "58b94588ec919fd802fc25cd209084ecc9acdfd99d5478d5ec76670774ff5886"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "646b92317193c0a8cab6f569216bea51e1fe9b2477974db2625a8ba26dfc64c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4e9a81c2c16eff25f9539063c87c24afd1efd3c2725b4d7c4ca770f60e19e10"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1b2a5242fec90e51e29b59e3b8d429fcdbe6db75b67b1b03862ffcc0679461f"
    sha256 cellar: :any_skip_relocation, sonoma:         "58a8dfea5933e2460cfdcdc4d49d4df631d0c4267db34e3f534119f992c802a8"
    sha256 cellar: :any_skip_relocation, ventura:        "d042d66928dc53539aa08d333f8fffa72d7b58e08879aa553d77e614c3a2167c"
    sha256 cellar: :any_skip_relocation, monterey:       "0d49fd677289d8d5cb7a54d12c97912168cc1a81e22af073e8df490b9e126669"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb2caa6206fe749a97be5724291c5e3b12920cf8a92a6b2c7821afaa868e32f0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output "#{bin}/bandwhich --interface bandwhich", 1
    assert_match output, "Error: Cannot find interface bandwhich"
  end
end
