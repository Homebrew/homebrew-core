class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.38.1.tar.gz"
  sha256 "b30d76e60be8f4928c3b7d5c3cd2d9034d60ad09c7e044bf2056f01e8596f46e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77b0fe3a801252277617abc9b34b478227baa31ebdff854ac429f7c5657e984d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "643b28fd5d356dfeed5634177805402defdb4988d6147aefd7a7f4ce9fd53b9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebc39d0360881ba0469383cddb9aae579df65ec9b013810ddec17c51547c0b48"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa7db040e5b2fd524bb5c95eeb3c3f140ed836c72fcdbc682fc8de1c5ab14645"
    sha256 cellar: :any,                 arm64_linux:   "05dc35003be292687560a86693e02498457050cefe69be6085307257a105c1db"
    sha256 cellar: :any,                 x86_64_linux:  "2121c23cfd07e48f2e38ae6006c8554aa307991948b6fe17598a1c27699d8948"
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
