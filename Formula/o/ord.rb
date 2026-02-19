class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https://ordinals.com/"
  url "https://github.com/ordinals/ord/archive/refs/tags/0.25.0.tar.gz"
  sha256 "e944e8548e226e8331f1593878f7719a2366b114e624ca265c646526e0959e17"
  license "CC0-1.0"
  head "https://github.com/ordinals/ord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b817e0a8bf1c5f43180a7e0953d4181fe718a5fb0d1c92c2f0bf96af913a7fb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "123a5b592c31f42eb655b841f7e1319f1bf377d3cc4e9c398ec7d060f61f796a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eeac8789e6887c93aedf97ffdb6ea476e42b0e142dd711afdf663f70aeedffe9"
    sha256 cellar: :any_skip_relocation, sonoma:        "708321d3ed65ae3cc0f65d75c61097a7ce00594b19e67daaebf5ecb025fc8725"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de56a07d6e5ab554aa739d081c37696ea02a0945ba50cf5a900d6156f1135cb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "576ff921a6bf3e458c93b61c940e1aa28db0f563669a36da6ea051a1ce0005b2"
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
