class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.7.3.tar.gz"
  sha256 "87cb934e644a30e4b53fdab322bac64b3e544090f62cd2a779db16a3e68469bc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c592d5306cdc7342582e28f722f1990d3dc76453d545d5d98bd4e8e374249cba"
    sha256 cellar: :any_skip_relocation, big_sur:       "7d92fcff976b3adcf040b5dc1571c3db7d562d96bacf06d688c300f1e11ede07"
    sha256 cellar: :any_skip_relocation, catalina:      "e369f34177e3a27144a8560d375f15907ed4d70b2e61cd7c5fb21b5af2116cf8"
    sha256 cellar: :any_skip_relocation, mojave:        "23ebf568871bcc6a91fc2f6f5c85fa13ca58c37fd6af2c7f8fb2f9c61fd41e5e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch testpath/"test.txt"
    cmd = "#{bin}/fselect name from . where name = '*.txt'"
    assert_match "test.txt", shell_output(cmd).chomp
  end
end
