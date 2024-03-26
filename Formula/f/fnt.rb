class Fnt < Formula
  desc "Apt for fonts, the missing font manager for macOS/linux"
  homepage "https://github.com/alexmyczko/fnt"
  url "https://github.com/alexmyczko/fnt/archive/refs/tags/1.6.tar.gz"
  sha256 "fc799acaa3cb9d038b26d753fb86e8cc5c09ffc3f3164c458b4d84827494c81e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b229a7fc67dd933e6651538c17a9b103877d1d2c396cc59b2657c147b1ed5884"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b229a7fc67dd933e6651538c17a9b103877d1d2c396cc59b2657c147b1ed5884"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b229a7fc67dd933e6651538c17a9b103877d1d2c396cc59b2657c147b1ed5884"
    sha256 cellar: :any_skip_relocation, sonoma:         "95687ee5860d1bdecaba8b81a981d3f6a57ee41fedb6f6a0266f6757a6e0cb07"
    sha256 cellar: :any_skip_relocation, ventura:        "95687ee5860d1bdecaba8b81a981d3f6a57ee41fedb6f6a0266f6757a6e0cb07"
    sha256 cellar: :any_skip_relocation, monterey:       "95687ee5860d1bdecaba8b81a981d3f6a57ee41fedb6f6a0266f6757a6e0cb07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b229a7fc67dd933e6651538c17a9b103877d1d2c396cc59b2657c147b1ed5884"
  end

  depends_on "chafa"
  depends_on "lcdf-typetools"
  depends_on "xz"

  def install
    bin.install "fnt"
    man1.install "fnt.1"
    zsh_completion.install "completions/_fnt"
  end

  test do
    assert_match "Available Fonts", shell_output("#{bin}/fnt info")
  end
end
