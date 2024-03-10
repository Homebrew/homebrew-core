class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.29.0.tar.gz"
  sha256 "af58bfc5146b296ced1ed711b0bbd21bce731a69fb6bea6622e6acfbe180a91a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "092e8c2087d8fb38821723147bf574c254e50729179ee5301b285137710587a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8602008d8ade174046473c34e369ccdf866d93d5deaa1b6e76b757abc205cc2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57d229f7d2590ed117dfd5cda87d1c392a9bb3f6115daa6797a895dfe4852045"
    sha256 cellar: :any_skip_relocation, sonoma:         "575b936f7c82cd2f5ed54737866cf0e15681b5b1131b6746bf6fde7cf596889a"
    sha256 cellar: :any_skip_relocation, ventura:        "b6f938b1f1940741c0060199f30ff954c87acf17cc10331672c52c31315cf29b"
    sha256 cellar: :any_skip_relocation, monterey:       "2b75145c33d81f6dfbfea3130e9c88bb821ffc78f89db288ef5d2bee1319b765"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c217823ca055b6c4db30d70379bbdfe8ce9c58993bfb6584d39381815eb27f3"
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
