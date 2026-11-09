class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "a4eef58525a9eb47bcde414b7fa6ef709c32a323115b8ac841b86dee0b11d6f0"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "91b44ee49339b9ca9470232c9bdac7469d320b6325f5dae463372791ac4973e8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "819ea0e793a55afda2dc803301be11674485c676f670cabc38f962fa2eb75dfe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b4fd708c5ca37c35959f3bb2b4e122aef9c61b43dc05c88fa822965baea57616"
    sha256 cellar: :any,                 arm64_linux:       "40b0f79f933f7d4bdb32f34f721005355935e865feefddff52c78b6e80454366"
    sha256 cellar: :any,                 x86_64_linux:      "38209a11ce2e531d819987bc490c94e1008954900652dba18e3670be5cfd1114"
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
