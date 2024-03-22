class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.29.0.tar.gz"
  sha256 "af58bfc5146b296ced1ed711b0bbd21bce731a69fb6bea6622e6acfbe180a91a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "41b81de15b5861ce5f498fa86dda98659eac1c435af87707cbf025f569754c03"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55dbf43f6a6f1898591f7668821733301344c7d071907d39481fd516af34bef1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e25573c322a111194255a44a6e22ba0c28ef53eb012c6a6eb61689f9f1327894"
    sha256 cellar: :any_skip_relocation, sonoma:         "697b01901e1739927e117751826b2281529cf881b37581b0f23311b77e8d5681"
    sha256 cellar: :any_skip_relocation, ventura:        "3e3d8ad351b3b405f7e3b29df8a55449950a0132c81cd8e4b0560b930d3269c5"
    sha256 cellar: :any_skip_relocation, monterey:       "3e1b4b301a075fd4af7dff95ff0694c02135f969b31d0a51d180b8e404c01f7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13f29acc7cb223068167243b0831794c67836b5be3ecaec3e9fd789d49dc540e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test that usage is correct for these 2 files.
    (testpath/"empty.txt").write("")
    (testpath/"file.txt").write("01")

    expected = %r{
      \e\[32m\s*0\s*B\e\[39m\ #{testpath}/empty.txt\n
      \e\[32m\s*2\s*B\e\[39m\ #{testpath}/file.txt\n
      \e\[32m\s*2\s*B\e\[39m\ total\n
    }x
    assert_match expected, shell_output("#{bin}/dua -A #{testpath}/*.txt")
  end
end
