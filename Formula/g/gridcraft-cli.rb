class GridcraftCli < Formula
  desc "Headless GridCraft CLI and MCP server to inspect, convert and script workbooks"
  homepage "https://getartcraft.com/apps/gridcraft"
  url "https://github.com/storytold/gridcraft/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "f705a50d96be1dcf6101fb0973b384fe40de5eff06981017136521d7ca1888a3"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/gridcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "07457244c89dce708b13359f39f4600866dec589fbb546202231c68e8792811a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2705d80381db743049675dd91055321945ddc794d28c19f775b9cc946abf5da0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "50ed6e3f759e1d0ab5b9935a607f7fd17e7b0b60dbbb2bb43bdc23e32db4689e"
    sha256 cellar: :any,                 arm64_linux:       "c60e736f1972fe3e62261505df1f76acaf06a4962d26e37d425dd0088019f3bc"
    sha256 cellar: :any,                 x86_64_linux:      "a5f4faa5746dc9493cf0eeb44533e072ff1037b95ef7ca5be8ee52e1d724eb57"
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
