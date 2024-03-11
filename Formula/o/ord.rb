class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https://ordinals.com/"
  url "https://github.com/ordinals/ord/archive/refs/tags/0.16.0.tar.gz"
  sha256 "f2d89cbcb78948e5906659702928e87abb2fec3d4c620de67db23fc8c2ad5fbb"
  license "CC0-1.0"
  head "https://github.com/ordinals/ord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "17cbbf5ff14f75caa640a347611f1a1ece31bf43c06a99c73c3520d2f1a51287"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff317f969e7c0cd85ae187174a9d5819c54d0947ef85796179a22deb44c9f0c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5675e9284a61c40443594f992a646253377ce8c74a09095af5a817067ff15ed4"
    sha256 cellar: :any_skip_relocation, sonoma:         "0fe8ff93fe36225a0f18ffd4c18b5b527ac4a5240d9101934cbc5de498291627"
    sha256 cellar: :any_skip_relocation, ventura:        "b06a107adfab1dcf771082a0e34a43b57882d26a2f444e651f33e18f3f65cb02"
    sha256 cellar: :any_skip_relocation, monterey:       "e649e46546b095ff90b46ae3dc5d42dc7ae36ffa99696ad03436e3289b6536b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87b3ddfa49e34b119ce079927a543ac5fcdb841158d9052cb315361887840dca"
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
