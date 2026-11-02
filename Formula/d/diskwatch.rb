class Diskwatch < Formula
  desc "Cross-platform disk diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/diskwatch"
  url "https://github.com/matthart1983/diskwatch/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "5acce57bd2e723b3c4164d6e364772c10585ddf43b0603dd588813318eef2d8b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "80e33f0ecb53e75ee4be7497a33daf76efcad570af321d0135a7441fa184f245"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "05ba43e7bb82b4cd06cff7cf302e7382c3f14d825f7e16751c95ec8bc9979005"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b28ea04c93dffe4bbbf4d989bca758d1223926860f86c6a107f0a0cf74492352"
    sha256 cellar: :any,                 arm64_linux:       "b60b8b4a29515d008eedcd12232a20d7baa86a33bda853036f70c12fc329e856"
    sha256 cellar: :any,                 x86_64_linux:      "a4b91337499119838c2f96fae556aa2645ab26c600c271adc789e3f76722c403"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Devices", shell_output("#{bin}/diskwatch --diag")
  end
end
