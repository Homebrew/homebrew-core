class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https://ordinals.com/"
  url "https://github.com/ordinals/ord/archive/refs/tags/0.18.5.tar.gz"
  sha256 "83c407bba9929d8b8e482560040113cb1b186e90b87f696932d9b52725077b37"
  license "CC0-1.0"
  head "https://github.com/ordinals/ord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "30deef20709b6b920eee8db6ccd6586ff1d870b0b282ac75b035c88e7d9bb62b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb79ebb973f1299e6cf4d4bb82a0166e5a954a6e6735284671584ab94eed4b28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca0fd66158ad2da8cadcb9e1acd7c26352d2cedb308861658d70382d0c32b19a"
    sha256 cellar: :any_skip_relocation, sonoma:         "a696e83593b2a82b891ce4cfb9da2b5e9d66be728dc7efd67d741b0ea7004b71"
    sha256 cellar: :any_skip_relocation, ventura:        "9327ed66c5f9e1aedb54f7d1d3351f7211beffab662530d9e41fa2d08ce422ff"
    sha256 cellar: :any_skip_relocation, monterey:       "dd803d2582bcf8f9876d8418249caa9858c5dc53b050fec8c6cc7e1ecdd2510c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66b81394dae6a72f71eff1e705739ff3b5b8a24a66b8a74b555f6e2b9d6f31ce"
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
