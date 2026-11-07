class GridcraftCli < Formula
  desc "Headless GridCraft CLI and MCP server to inspect, convert and script workbooks"
  homepage "https://getartcraft.com/apps/gridcraft"
  url "https://github.com/storytold/gridcraft/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "eabb7f383f45b98d852b5a4787ff16a6fcbaca3dd1aaf9213a69de78f14fdc75"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/gridcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "90d653d25c0f60cd8f8b8f63d0ced380541db33ab70d6d4d32ba5269b03476be"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "27d244c49f9e054bbc93db462eeef7444cf720c3ca3371d7424e0bc71689afc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "69292889a4696c9e4d470e10dca82c2f50ea2c22cc7094ffbed577056349f88d"
    sha256 cellar: :any,                 arm64_linux:       "adb9818ce0ac042229de3f9ed393b5410199bb3b73fd319a465283282c3b7a6f"
    sha256 cellar: :any,                 x86_64_linux:      "4dec110f93b3157e618d603e9eaa4722da8064869cec3c29c5d73b121a533625"
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
