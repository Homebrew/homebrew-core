class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.19.tar.gz"
  sha256 "04e84f790dad95b90699bc241f854aa14819575c46b517fc5ccfd140f7fbceb1"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36c875968df4ab0301cc98ce87aa970347d0f5162a510037d8d2dc9854624e1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "080ed421d1221452fc2521781d7596e1c09bd19b0789a98ab932c300ee4362d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6f5a314f1acc4babec211804a755557d5fef6087e90403cf616923e14d1789f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c4dc783019c7daaa28af5cbd4d4aed5f3b8843a7315410e5130a6b1215259d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f13cb9321480abfb0d154342ce2ff09ba82d5f72cddfcfb78538f8131b2a0252"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29d580d860cf532e4a8056457fc0668a68d2aa2debc99a76f846d094e0ca7ab5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}/cdncheck -i 173.245.48.12/32 2>&1")
  end
end
