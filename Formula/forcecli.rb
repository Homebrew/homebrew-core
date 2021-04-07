class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/v0.31.0.tar.gz"
  sha256 "4c4ea4b65bd096a444a56a6b314950a5977879fcae329ad1654db0f765cf402b"
  license "MIT"
  head "https://github.com/ForceCLI/force.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "60532d6e6bc4c66faa653c0d0ec5751ba71e2568aae2795d696cf8b7bd879d1c"
    sha256 cellar: :any_skip_relocation, big_sur:       "14a125902ca1284ba17949d6705e5e1de3a1a60a42aebd9227d18ecc5d504dbb"
    sha256 cellar: :any_skip_relocation, catalina:      "ac4f78f1bb63c54bf3073cc3ebcef8f3c51cbad999c5c9c9b6b2614acb207736"
    sha256 cellar: :any_skip_relocation, mojave:        "5e38060873c89ce912affa5ad1b82636f75451a052e2d7722f796b1c087ed1c4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-trimpath", "-o", bin/"force"
  end

  test do
    assert_match "Usage: force <command> [<args>]",
                 shell_output("#{bin}/force help")
  end
end
