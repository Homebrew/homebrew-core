class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/v1.0.2.tar.gz"
  sha256 "b52441b0aab0c17e9303a33d1d1e27394639cb45ca1a18b9a85e06efe741fdef"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "282a86ccf4f28ce93eb631e532e183289d63d192aac50368373857a130abea4b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "282a86ccf4f28ce93eb631e532e183289d63d192aac50368373857a130abea4b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "282a86ccf4f28ce93eb631e532e183289d63d192aac50368373857a130abea4b"
    sha256 cellar: :any_skip_relocation, ventura:        "44ff4dbd274d3a9f51fdd9ceac5500a9885eebdd89e42c9e9ad238cb78e9d05d"
    sha256 cellar: :any_skip_relocation, monterey:       "44ff4dbd274d3a9f51fdd9ceac5500a9885eebdd89e42c9e9ad238cb78e9d05d"
    sha256 cellar: :any_skip_relocation, big_sur:        "44ff4dbd274d3a9f51fdd9ceac5500a9885eebdd89e42c9e9ad238cb78e9d05d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eaef30e57bbb22fddc42c213a1d1100f5f74a0ffe209f434e9d065bfe5ddb9dd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"force")
  end

  test do
    assert_match "ERROR: Please login before running this command.",
                 shell_output("#{bin}/force active 2>&1", 1)
  end
end
