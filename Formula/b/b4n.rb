class B4n < Formula
  desc "Terminal user interface (TUI) for Kubernetes API written in Rust"
  homepage "https://github.com/fioletoven/b4n"
  url "https://github.com/fioletoven/b4n/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "990f7188ebff2d68de8297a59e562ecb738f3245c368a63c3d57f5ddc4b5cf57"
  license "MIT"
  head "https://github.com/fioletoven/b4n.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a97fbf91c77ea54a80f480ac78f6b8d1024e7437367eafbd82acc594d54eec9a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bfce9acf64f55f33c8ee418b82c552a6a2384edca6aad70e59aeb1f2583ba2a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e09a40e83e77ca049d3f46aaaccb04eb9f67ac14b6de2d3b71d4ef26ed706fc9"
    sha256 cellar: :any,                 arm64_linux:       "5917ae5e5c8db09a19890a8057b5cf998e8a7a863acc310ee839aaeed0a988a2"
    sha256 cellar: :any,                 x86_64_linux:      "eca3d99137f7e67cc7338850218bcf4521fed15e9201d67f67fd727934a6af2d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # a cli will complain on incorrectly configured kube context or config file passed
    assert_match "Error: Kube context 'none' not found in configuration.",
                 shell_output("#{bin}/b4n --kube-config=/dev/null --context=none 2>&1", 1)
  end
end
