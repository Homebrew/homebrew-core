class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.21.4.tar.gz"
  sha256 "5a6482b4c8f719b90fa1bdf40d44e8197f99d3b0b60753dfc2f1109bdf6f4911"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33a23e2adceae00652659de27d027c547fc43ac719ef28a087c01bb89c175ad4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "892121671a0d4df004e4d0867880b51226e6617d6fd64dac1f1fc24180842bf0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd53f102a0405481d03c7b723de8b5ebd9eb149bb9db3b1d7e90e46ee48e2376"
    sha256 cellar: :any_skip_relocation, ventura:        "c2b704b7874fa209cb9f2b978d7f363faffa44e13ee063f041ede7b284740694"
    sha256 cellar: :any_skip_relocation, monterey:       "294fc39bf50f6829b2cfbb3d484603b76830a300bf62549235fd4b37012124bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "6330b74e84d1c4d9cf7bf303e14fad15f9d880135f7f2a45c84f803677be65aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfd4d0b258e03673f4adbbbed7e46d1c964797aac883b79c8759fea225ee36ed"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "httm.1"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
