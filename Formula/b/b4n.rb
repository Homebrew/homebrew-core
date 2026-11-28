class B4n < Formula
  desc "Terminal user interface (TUI) for Kubernetes API written in Rust"
  homepage "https://github.com/fioletoven/b4n"
  url "https://github.com/fioletoven/b4n/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "e810c7faa7d5c05e25b796e30b29449b06254071653b6d042828c59d1efc91dc"
  license "MIT"
  head "https://github.com/fioletoven/b4n.git", branch: "main"

  bottle do
    manifest_sha256 "e11799320b1bdf61457fddb1d0dd9c95d2e63fb020efc6e744a44a7b4e507189"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "595f7ea8364ce79bb46c113095ceef2318828224317d45e46a9f2037d8ef0962"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d3a90b1478ba38ceeb02943962062c74e32b40bd2df0adfab248f3d1de39c447"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9039961d191c6c4acf680cbea0d0fea974082445fbbfed81f5507821a44bf034"
    sha256 cellar: :any,                 arm64_linux:       "16f0140ec298680f0194be72538f2d59ae81d68efae7af0a9554619e06b5c757"
    sha256 cellar: :any,                 x86_64_linux:      "d8bb773068c81eb45bd93ed12341fbc3326fe7ea806ebe9f680facbf6d3450b4"
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
    # a cli will complain on incorrectly configured kube context or config file passed
    assert_match "Error: Kube context 'none' not found in configuration.",
                 shell_output("#{bin}/b4n --kube-config=/dev/null --context=none 2>&1", 1)
  end
end
