class Presenterm < Formula
  desc "Terminal slideshow tool"
  homepage "https://github.com/mfontanini/presenterm"
  url "https://github.com/mfontanini/presenterm/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "c8a2bcc0dfad327d86fb21d236155966fde07089db34f5876c6f4b11f6561679"
  license "BSD-2-Clause"
  head "https://github.com/mfontanini/presenterm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4a14e3b9f13846e6ece2a27c6d610eee4a294ed3ea78fde3bdf69fb6958ecd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e1432928bd172c1d79605d9d2dd07db33f47de689029beaa1e271a7585445b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fc2d37dde37f5413a3b9c539c4a1b076bf5bbc5a7a7eccb7c91a0bf9c45df08f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b010b98f9c0829088be2615dbf228130ee9aca569835ff7ec1027da51eee3b19"
    sha256 cellar: :any_skip_relocation, ventura:       "e00a9c7d5bf50c10112f2331b17417095797a2b35c52367bd8487b7a0f913fbb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2b8f147eda12d96e22511ccc3536d2a54035869b02b89eb78146ecd1448a315"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc3eebc948aae1f7b5f2a0770508430ee04003be90264e03b9a785158431d7ff"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # presenterm is a TUI application
    assert_match version.to_s, shell_output("#{bin}/presenterm --version")
  end
end
