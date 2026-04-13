class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.34.0.tar.gz"
  sha256 "eaa924f50efb425302c124f170644e95a08f8dad1f627b86f50d033ca5feb0c1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aca8d61ff41e16b5708e4a7a4daf73f369db05fd86734d49ddef87214f12cf62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68ca0ea1daea555fef6fde7a1471d8770ba37d9df55af523b36e8fa02cb14db2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f5cf8aa21369c808764be57be86cfa9153fe5b9029dd8ecf3fc30b8c30268b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "167298ee7d3642fad5baa3023b1692f02e5e904290c9ea20eb73a744e65ddf1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d57e7759ee1184d42909506150937e0f040def676813144e56e800db16a213e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f043a8e2a70d5deaac4544c9ec784f6f47e79f0be891681b1fdb26fc341417f"
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
