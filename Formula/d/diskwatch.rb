class Diskwatch < Formula
  desc "Cross-platform disk diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/diskwatch"
  url "https://github.com/matthart1983/diskwatch/archive/refs/tags/v0.5.8.tar.gz"
  sha256 "4768e2d8cd86c470f93e152bb262116c75b6316c4b19fa963a4c19888bf18c73"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "98faaa2950a02f9aec9aed2d7c7bc185fa3e605e0ffb3e0fd0bf239ba887292c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a26fb37e30887a4164b48778607d190e418c5f241a0ad8ee24d7067f3425346a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a3354079dac8823dcfa2757c81a165f378cd3db0f65ebedbfe6a7bd86a70a0f5"
    sha256 cellar: :any,                 arm64_linux:       "1d225e4361d7d5231e43e74cd39a28c0ba26d33f181af927235b39ffa71cd7cb"
    sha256 cellar: :any,                 x86_64_linux:      "c8b6878b46bcf601ab9a117da01acf4e00d4ccbc651b6b5837d83820d7c42612"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Devices", shell_output("#{bin}/diskwatch --diag")
  end
end
