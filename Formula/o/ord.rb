class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https://ordinals.com/"
  url "https://github.com/ordinals/ord/archive/refs/tags/0.19.1.tar.gz"
  sha256 "76a1bcd12a465fb5beb61324b9ce9107e69a1f09dae1d424670a3e6b60180624"
  license "CC0-1.0"
  head "https://github.com/ordinals/ord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e54d6c8a8d6bcee853a0078100e111c6c57199d21736f11b22508feed29babcd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ffd3b0f5208faf314d12ca105b32dd7263557e78136ba8cd5a94f94823beafd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "514ca40fccfa04a407f985a11a0fc6aa04117ad371c00d43f70003155eee205b"
    sha256 cellar: :any_skip_relocation, sonoma:         "0253b1c22acfd4bc4a19eb781b5ce2987fad834bef3aa0d411e402ba6552f7cc"
    sha256 cellar: :any_skip_relocation, ventura:        "344171e18f12aabf36a11c9a756f7dd0bd98ed1f1ec137abd84bac2f334bec46"
    sha256 cellar: :any_skip_relocation, monterey:       "ac8b42b39c34877efe3d6728751f1426427825068ef2dc895728ba5119e3a48d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "773f415fcd4837cd1dc4466218642fddd7815e4404781122a6393b3898a98df5"
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
