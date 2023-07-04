class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https://ordinals.com/"
  url "https://github.com/ordinals/ord/archive/refs/tags/0.8.0.tar.gz"
  sha256 "984a53cbf31996fef2b6a38dab049d7d41195008261616b3403b6c6b13821dfd"
  license "CC0-1.0"
  head "https://github.com/ordinals/ord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be169ee2971aff7445c072eed1c73372832fa2d894773e35c6f08aa01095d7c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "997bdde4b7a26de79f0eacadae1ddfa2aa0c1a424ebf45ffaf288cd788c1cda3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30c4232a1736174734027afcda6ceb0defdd5ff5e395f440dd49aedb259eb347"
    sha256 cellar: :any_skip_relocation, ventura:        "5aeb6a7aa2d1ed5f81922d4afd139679ea322c6f9ce237c81fffaef0605297db"
    sha256 cellar: :any_skip_relocation, monterey:       "f50bf9063250a0bc17b7fa2d5b94e02737f91dbcaa4d54f5efd87b9a2bfce151"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf88656b27a9d93de47fe0d465ae47847c63d50bb199c7146ac51743ac460506"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59245091b9e7a57fef1c70f31a1eb266d585d4924fac701dadc6767a1a48b71e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    expected = "error: failed to connect to Bitcoin Core RPC at 127.0.0.1:8332/wallet/ord"
    assert_match expected, shell_output("#{bin}/ord info 2>&1", 1)

    expected = "error: failed to spawn `bitcoind`"
    assert_match expected, shell_output("#{bin}/ord preview 2>&1", 1)

    assert_match "ord #{version}", shell_output("#{bin}/ord --version")
  end
end
