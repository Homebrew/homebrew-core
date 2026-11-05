class GridcraftCli < Formula
  desc "Headless GridCraft CLI and MCP server to inspect, convert and script workbooks"
  homepage "https://getartcraft.com/apps/gridcraft"
  url "https://github.com/storytold/gridcraft/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "191e0b8ef1e519a2ebed782937125330a1ed73e9b3ec8ebc2287b88cbd44e388"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/gridcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e580a21090bbbbe75758db121454f84d79b3a57a2a0f52dd1b89f34fe8b06869"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d643860ac3b2411177d057e63ab29b781c9b2b2d96b8f57deeea80bfbd98e4f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "166e0ae4a7f8248027a99501b80bc3cf4bd01b89e6f1698fc794fe306df9ad48"
    sha256 cellar: :any,                 arm64_linux:       "4248eea127fa74167f04ab6377d7748ceb74b0ce636fe66cfff335d6d7cabb9d"
    sha256 cellar: :any,                 x86_64_linux:      "4853ad577f56b2b541d6facd2740700f0503facb9385e226eab45d343a16390e"
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
