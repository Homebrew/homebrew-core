class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v3.0.3.tar.gz"
  sha256 "e1918a15a39ec1f25a2f16f8395512b21025221ff9b0a5ba9bb8eb6b17a4178a"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ed4c982ad2c3b84807659a968f76d1bba26cdac07e9c4eceec230546af932be4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9b4030669c1997dd81ad26ab3909526516e0c4b0c55e3783eed9b090274124ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e9d2ebd0569f816e93c244e53b84973ade6f964101d8601deb570b5f26d9d04c"
    sha256 cellar: :any,                 arm64_linux:       "e569119500e6a88a8e21e65bf76b8287acc036bde229049a419fb79f355c65ba"
    sha256 cellar: :any,                 x86_64_linux:      "51451416763284551e544d0f315d567ac122210804f90f1d5904e1cd0ae8346b"
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
