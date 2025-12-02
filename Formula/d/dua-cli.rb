class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.32.2.tar.gz"
  sha256 "8a3495d2ec0c9bee961e512c79b11c9945797a3d4f979b4ec63fd50d73d80c94"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45195139fbaf4b37893ac5cbddb41eadee7f9c21ca88c09b333fcc7d657cc550"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2736210432d3d48b661c3b76bd6a66f610c3c2039a4ffcb19afc2a6182c39038"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67cea135c33f807bce9a898ab78a4eba365687e8c86781af40831dc6d5db57d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d536b71698faac029e94d5209d7d6d712ef9d82998ede0a6db07b5c1d4cecbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "113df40fadd63e850c57c9441bde91685fd2366728dc77d013d28ec25e59196a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc785849b7c2d16eba2dce9fd9f962ebb6cde23f50810f97b1b38919d49594e4"
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
