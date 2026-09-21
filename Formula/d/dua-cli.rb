class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.45.0.tar.gz"
  sha256 "f78c8a7eaa9967b81ce86aab9b66b6e9e617b1ed41b334e95cd1c1ded7a70d14"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b4cc77fc3c88c9a70f8bea913e2bc6bce1e4ffe1972f7863ce71fceae907fd17"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3e976c9690db890de466b1a7aba586000728cb2c5ebe13d549a33839c60e6b60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "098b6c0da83a7d2a845d93eacedfdbdc0197464a7d0985f0736640d691fa4b93"
    sha256 cellar: :any,                 arm64_linux:       "9c7d90387e344c9411622f5b2d8625f2c280ab8f9c2b604a7e5c889c978911ac"
    sha256 cellar: :any,                 x86_64_linux:      "02591d4c6e46cd502654e7c7f51afffa1c38451e75a90ebbcb865b2139d693b4"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test that usage is correct for these 2 files.
    (testpath/"empty.txt").write("")
    (testpath/"file.txt").write("01")

    expected = %r{
      \s*0\s*B\s*#{testpath}/empty.txt\n
      \s*2\s*B\s*#{testpath}/file.txt\n
      \s*2\s*B\s*total\n
    }x
    assert_match expected, shell_output("#{bin}/dua -A #{testpath}/*.txt")
  end
end
