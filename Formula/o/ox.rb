class Ox < Formula
  desc "Independent Rust text editor that runs in your terminal"
  homepage "https://github.com/curlpipe/ox"
  url "https://github.com/curlpipe/ox/archive/refs/tags/0.7.7.tar.gz"
  sha256 "9dc869836e92beb5806739da25bf929b45bbb4173a6bffac31b762fcece74a0a"
  license "GPL-2.0-only"
  head "https://github.com/curlpipe/ox.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a82610add3dfd5db1da081200dc059858b37fce50d927b991f3c6c66a113279"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f9eb95e6a465fefc00454f9f2df68ca87ef65122639b18f8b65b2ebbf8b5240"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23832d0a48c0c8362ec6e5794f03aae01781ded51f96f7d8266365ec24c9a3ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dc6871adc3a09c2ba19334b0fdcaae54ea1eae9d6631763577a613d025385379"
    sha256 cellar: :any_skip_relocation, sonoma:        "c468c1a3b8020dcc6a5eed5e715c64ed474501016fa48d205a1aa0e8fadadb32"
    sha256 cellar: :any_skip_relocation, ventura:       "9fd801439a60c7ce8bbcaa72b7c2f69c5fc7d25f58fe392677f07aab9a7ab6c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31fb3bc58c5857cc0aadcef6a5601cc0b4b7bb7ea2fd47b5ca12d3739d044859"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f56fa97255719ee87aebf29c4ba0b7afdc917e399dd6dcc3788e088699136de9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # ox is a TUI application, hard to test in CI
    # see https://github.com/curlpipe/ox/issues/178 for discussions
    assert_match version.to_s, shell_output("#{bin}/ox --version")
  end
end
