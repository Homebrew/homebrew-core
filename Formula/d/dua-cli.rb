class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.46.0.tar.gz"
  sha256 "321e06440a8ba5dd05ecfd78904a127c9ffa556a40d886ab5862a9fe9aa9bd21"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7e728ed0d5b741cab050256709ac34aee81b0d2036de23a87be16afb87054544"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a93918412fd520729b20b3e6cc7a4d98f4dbb811d7a3f79bf88a3a0ff696f2b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "abfd426181cc6a25d5e39861268c6b64d0a051f410a90f2e28cdf9ecd7ac9669"
    sha256 cellar: :any,                 arm64_linux:       "1b0d58074619c7eb1b276bea9b3aa8e40f9348cc38604921397aae5f3c953072"
    sha256 cellar: :any,                 x86_64_linux:      "15eb1f2db2dbae8ec45312acb94895df780a2faa85097140119c2dab3c34ec8c"
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
