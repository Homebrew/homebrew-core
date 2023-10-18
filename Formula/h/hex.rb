class Hex < Formula
  desc "Futuristic take on hexdump"
  homepage "https://github.com/sitkevij/hex"
  url "https://github.com/sitkevij/hex/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "a7cc1ece337fc19e77fbbbca145001bc5d447bde4118eb6de2c99407eb1a3b74"
  license "MIT"
  head "https://github.com/sitkevij/hex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4326bfdb2206fc2209a2cfe3ba7e2cc7432411c7d1a3811f3cc6149d214f65a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "245116da00ee18fb6c48ddbd0083b62e86a41957f2b599b47d51ffec1a5adcd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d926a35caa10284418a160ec7a6cb5cb44121d2fd03b52d84fe7734196b4524f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de567e3c63410e409c9d2940c0b95db95a1a7b86ef3b6583a701d0b6dfc4f77e"
    sha256 cellar: :any_skip_relocation, sonoma:         "5f95efa77c3bd0efc60bd67aba2f112e89223e39f8a5fe6f131b00b6a97a9f0a"
    sha256 cellar: :any_skip_relocation, ventura:        "f91fdf2c20304970c38cd1aec11cbe0e5e416917f9c22a4a19cd7d2d395f0401"
    sha256 cellar: :any_skip_relocation, monterey:       "3630ae16eab4b22999fd1f4b34bdd69a8de15a63973f82268fb45dddbb5f080e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4e9bcfc557b0325b96003c1626506f4c1f66ad0a6dda54b9a8868c251a61ba1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "965b7895b352c914b2bf1a8b26bff934adf9eb5d6223a3da309b5b57154e31c0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"tiny.txt").write("il")
    output = shell_output("#{bin}/hx tiny.txt")
    assert_match "0x000000: 0x69 0x6c", output

    output = shell_output("#{bin}/hx -ar -c8 tiny.txt")
    expected = <<~EOS
      let ARRAY: [u8; 2] = [
          0x69, 0x6c
      ];
    EOS
    assert_equal expected, output

    assert_match "hx #{version}", shell_output("#{bin}/hx --version")
  end
end
