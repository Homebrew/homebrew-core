class Diskwatch < Formula
  desc "Cross-platform disk diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/diskwatch"
  url "https://github.com/matthart1983/diskwatch/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "6db71340de19564fdb3e1358e1ae31a57815d4729e8d24e6059bd491a79d8841"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3821b795e2112a9718731d06aaf4519eda25c06bbad9f072a027ac3de12a2dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32210714a1176eeb20c767bbf89009257cec8568c2ce6a365650cd2e406df6d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f0483e219b88d1a4285c56a77c57b0c852539f8243e9bf5d08ae2333755ba6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4094966770bd3d0f6ce2dfeaa288ac6ec1727441b7f1f014fd933eab2571c640"
    sha256 cellar: :any,                 arm64_linux:   "5d362dcb6e9f73ea49542fd9f3dcf9ea0b49826d5d3c0509f1c37dace33910f8"
    sha256 cellar: :any,                 x86_64_linux:  "22bb17f5e581bae9cc4a53ad1541370917afba154f7ce3a6182086c63c3bacb5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Devices", shell_output("#{bin}/diskwatch --diag")
  end
end
