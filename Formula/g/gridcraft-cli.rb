class GridcraftCli < Formula
  desc "Headless GridCraft CLI and MCP server to inspect, convert and script workbooks"
  homepage "https://getartcraft.com/apps/gridcraft"
  url "https://github.com/storytold/gridcraft/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "40beb3e9609951abab4ef5ec51a21f0d523279fb56ab68163be8fd835a33127e"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/gridcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7319e87c2222e8c6f9d8cb23b2b470f5d239540ee06820c05cf7e9e9fdad4692"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "540b5dd5cd866230f58714cac6ce7c4c6f783f9fc67e699ab17016b2c2cdd32f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "81638c2c59068566539c924d85a63d55003c0cba01cc065d0edb1f9ee971ba75"
    sha256 cellar: :any,                 arm64_linux:       "39f765e074bc82818c92fc0b8baf23c91c4db8aeae7c8d71d354c9b1ad9f597f"
    sha256 cellar: :any,                 x86_64_linux:      "2aafff5a7fc9e0f83a1913ab1279b6b4b99335cfe73cf82662b914f5c27df6db"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/gridcraft-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gridcraft-cli --version")

    (testpath/"steps.txt").write <<~EOS
      cell.set={"cell":"A1","input":"Apples"}
      cell.set={"cell":"B1","input":"3"}
      cell.set={"cell":"A2","input":"Pears"}
      cell.set={"cell":"B2","input":"4"}
      cell.set={"cell":"B3","input":"=SUM(B1:B2)"}
    EOS
    system bin/"gridcraft-cli", "run", "--script", "steps.txt", "--out", "test.xlsx", "--quiet"

    info = JSON.parse(shell_output("#{bin}/gridcraft-cli info test.xlsx --json"))
    assert_equal "A1:B3", info["sheets"].first["usedRange"]
    assert_equal "14", shell_output("#{bin}/gridcraft-cli eval '=B3*2' --in test.xlsx").chomp

    system bin/"gridcraft-cli", "convert", "test.xlsx", "test.csv"
    assert_equal "Apples,3\r\nPears,4\r\n,7\r\n", (testpath/"test.csv").read
  end
end
