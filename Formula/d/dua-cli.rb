class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.42.1.tar.gz"
  sha256 "31a452ce11ff6246da6298b70f892ae6b575eea5669adfd438381afd2157f748"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3c9710c4e41c26f343c547dc513bac57f042b867c21a87ee7c49c95afa23d68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67f70d319699024b2f7e350cbb09d43d342d86b35cdc5a532db673c38a17ac99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b159795c77d09dc604c664e75d636f8e126dacbb7930081559ea5ba1d336a7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "eaceacce70428ac52bcddc5d76a90fcd501e2df1b3bed2499d9b44e8809b2292"
    sha256 cellar: :any,                 arm64_linux:   "38c6fc2132cda34fa1222d9544526eea8190358dbb2447a80e8782335849828b"
    sha256 cellar: :any,                 x86_64_linux:  "4cd3d267cd9f6ff839a49ae3d29c8cfe6740f4fdecc268bec2906152678f50e3"
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
