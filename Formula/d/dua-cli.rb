class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "d178e30610b29b23b2ec478bb4ba256a01b82c8497895693e6cd92682bfcd4bd"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "613e7a7cd79cf7687dec7ee9e7d138fa7ac9e719c5f6ac88c03cc9ed3b3841d6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "49d768ae28d036743dbe54992af4a964abdadcb840e8338c8a2f708537a1c77d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6a0456353691af7a34911b2be6adec9f68e76a90c8da910ac836060aa3131418"
    sha256 cellar: :any,                 arm64_linux:       "ab085cb1856d472985d5dbff03d0843c678c6c6e683029dee65550a88facbf92"
    sha256 cellar: :any,                 x86_64_linux:      "0630454f52e633c4571f33e24badc7d3666538be3a34e2b25b71af22a11de347"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"dua", "completions", shells: [:bash, :zsh, :fish, :pwsh])
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
