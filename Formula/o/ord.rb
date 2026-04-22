class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https://ordinals.com/"
  url "https://github.com/ordinals/ord/archive/refs/tags/0.27.1.tar.gz"
  sha256 "032cc27775e2a6fa0ccb92afb44ea37f35ea38b58a7b413759ed65ab4ad1d5e0"
  license "CC0-1.0"
  head "https://github.com/ordinals/ord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "adecb3b51924055c92e8560d77fad316632e3a272a04779f698627db48067621"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9abbf1074988e3db66b6d498000a92e60ca81b2790ea4de9907b3fb01065352f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7688da465f0e1fc76452989c2c907960775ac5ff5d2dc200d4fe69d90872f5a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "aaa2622bd8a3673d9e846f40dd54a74eba9e5b273f7b727c2318ea41f3825fd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ca0e065daef5811382d11861d5ca6de9535dd3ac0b71152f5cae69f594f979f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac94987211d6d4959d69fabee084a737923586cfd53eaed49566802a78923648"
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
