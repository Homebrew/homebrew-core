class GridcraftCli < Formula
  desc "Headless GridCraft CLI and MCP server to inspect, convert and script workbooks"
  homepage "https://getartcraft.com/apps/gridcraft"
  url "https://github.com/storytold/gridcraft/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "6bc25221fccaeddd11bb98d31909880719ee9f06ef149520204a368e138c916b"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/gridcraft.git", branch: "main"

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
