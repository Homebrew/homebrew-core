class PySpy < Formula
  desc "Sampling profiler for Python programs"
  homepage "https://github.com/benfred/py-spy"
  url "https://github.com/benfred/py-spy/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "dc73c284a54ace20e62cf3f032c98bbdda5e36ae57795d3b0e538cd3ba2eecef"
  license "MIT"
  head "https://github.com/benfred/py-spy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6370cee53708d66ca7539e9e6a95f0a13b978262ec6fcc8a9a628bb3fa3ac8f1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "42f159f949ab8feefe35d75b50d66415b4926c0db421e13d8ee5f6159ad92786"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2d07ce1508957613c0624e91d9dd406cbbae796904002ce7fcefb4d10da48466"
    sha256 cellar: :any,                 arm64_linux:       "fa3a928d93ced795a90a77ef5d34cdbba9740061f16dd649ca43119d978979b9"
    sha256 cellar: :any,                 x86_64_linux:      "9acb3addeae800d8544c74775038ff5825c2b7b117cc7cd25dbc81a41e29404b"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "python@3.15" => :test
    depends_on "libunwind"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"py-spy", "completions")
  end

  test do
    python = OS.mac? ? "python3" : python3
    output = shell_output("#{bin}/py-spy record -- #{python} -c 'import time; time.sleep(1)' 2>&1", 1)
    assert_match "Try running again with elevated permissions by going", output
  end
end
