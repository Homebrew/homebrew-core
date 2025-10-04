class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https://ordinals.com/"
  url "https://github.com/ordinals/ord/archive/refs/tags/0.23.3.tar.gz"
  sha256 "381f8c7a788f8a17e40cd5ce8e3663c0862bb23f8e2313eeaf742721b758f5b6"
  license "CC0-1.0"
  head "https://github.com/ordinals/ord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45451e4238552bebe9ef582f49900f396e76498abefd181ba1954829f3165321"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "811e865257723cc0fb3e4c9065deee1533b99aa0861afe549869842f80710d6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6167b39410518447720663d3049575d7bd23b4d815c4cb622b85c4c5d5cb8823"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b7bdd358900338e5526b944e208f5851577626acbbb706f66f65759c3b191a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51bf08b0d7d0ec47ca4266c11702d76aef85fe389e982bab37340a9fb62fad21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98a45830338b5bd8c3d648f605ea6c2f741889e622d2cd2da1ee37d1ee8a08b0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/ord list xx:xx 2>&1", 2)
    assert_match "invalid value 'xx:xx' for '<OUTPOINT>': error parsing TXID", output

    assert_match "ord #{version}", shell_output("#{bin}/ord --version")
  end
end
