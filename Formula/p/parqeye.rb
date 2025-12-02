class Parqeye < Formula
  desc "Peek inside Parquet files right from your terminal"
  homepage "https://github.com/kaushiksrini/parqeye"
  url "https://github.com/kaushiksrini/parqeye/archive/refs/tags/v0.0.2.tar.gz"
  sha256 "67f896a9fe53a9f85022bdaf2042ae196feb784d2073df7d25eb37648d620139"
  license "MIT"
  head "https://github.com/kaushiksrini/parqeye.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcdbc3ffdc5238b1d30348983dcc47c1c25a59a1d6a386869780cc99eb3faa98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16711b77ea4001da10c1fbd696f74c4e37704059556327a70ac8e1ebd065cd0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69dfee9b1c5cebbdeab45ff50f14d450cc582f04e19ef8dbae922b9f7c3e32bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f58d4d3834b9dd677ea7f720bcfe4c02dd36c65f28fa8231a227743830041fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9384c8f25f40c24911f5329fa86ade59496a29b95de02028c4f6c063e96589c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06ba0ddaec37c77ebe2260ff8aee31a0537e540bd1f0495742209c514b296417"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/parqeye --version")

    # Fails in Linux CI with `No such device or address` error
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    (testpath/"test.parquet").write <<~PARQUET
      PAR1
    PARQUET
    output = shell_output("#{bin}/parqeye #{testpath}/test.parquet 2>&1", 1)
    assert_match "EOF: Parquet file too small. Size is 5 but need 8", output
  end
end
