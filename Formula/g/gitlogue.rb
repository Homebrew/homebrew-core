class Gitlogue < Formula
  desc "Cinematic Git commit replay tool"
  homepage "https://github.com/unhappychoice/gitlogue"
  url "https://github.com/unhappychoice/gitlogue/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "cf0814005bd39c02b7c48d385a258e2e4e1fd57980bb57db72ecb490494de06c"
  license "ISC"
  head "https://github.com/unhappychoice/gitlogue.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fa5b9b9dbf5657e107662f0b89322ea318974880d2fa7cca8a6ddf70661f68ac"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2e3a72a19029a95c36e5b8371f77dfa920396ef4cc9de7a92291b27628e3c5d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4139f6d66683b69298e15077b9944a7d0710ab3921fbf00ac06b0649592bd585"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "59eb342cc7c8b5775e459ba7568adc110bc9dc6fd17ce33c16b93fa949cc2078"
    sha256 cellar: :any,                 arm64_linux:       "9701d92549616f3c0c3317a58d6817b1f97bd0b81bce0e536f9ba42699fb7b3a"
    sha256 cellar: :any,                 x86_64_linux:      "cbf5f41b66b0bd919d1746bfd2049c1c6f2aa38b0cab906df5d462b1c8da5f87"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlogue --version")

    assert_match "Error: Not a Git repository", shell_output("#{bin}/gitlogue 2>&1", 1)
  end
end
