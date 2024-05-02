class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https://ordinals.com/"
  url "https://github.com/ordinals/ord/archive/refs/tags/0.18.3.tar.gz"
  sha256 "994dfd0da58db8300e5351de134f96f1f74ba8e3c5670f34d3dd32ef9f37078c"
  license "CC0-1.0"
  head "https://github.com/ordinals/ord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6faafbfa8fe09b1a52fee3a82d041fa35e05bd592b3e659565febaf23924de4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1a2ef6cf5a78af3fafde59d109508b2c7a07a10da2becdd3a9eda5c81493754"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54c5d9410501d044b82532635740c0aca3bdfa1d6fbdee01a95fa251c593c086"
    sha256 cellar: :any_skip_relocation, sonoma:         "134a05d3a26490d6b3eee7efad00346c68b299e4761589140e68fc8e1689a393"
    sha256 cellar: :any_skip_relocation, ventura:        "641796552d4f15283ed1bb7153897e8a021771f294b2f588cb027db60395f4cc"
    sha256 cellar: :any_skip_relocation, monterey:       "42fe7b60274e04ce1ff463c661b05ae3ab54d3ba4abf1c565c6a6df12d103d58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1613516b5a5697432abf5da35616361d1e630eb103fe809123656a373298ca17"
  end

  depends_on "pkg-config" => :build
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
