class GridcraftCli < Formula
  desc "Headless GridCraft CLI and MCP server to inspect, convert and script workbooks"
  homepage "https://getartcraft.com/apps/gridcraft"
  url "https://github.com/storytold/gridcraft/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "4adb7b981de97f31c61e5be67ac7b2bcd84e2559647b5c8c39561bbcce199c5e"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/gridcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3b21bf56f2327f7752a019e620eca3f90ed6e48bc32db4e237c532b2be392346"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ad75edfdb0cb767cafe513f360ac6041cac9587c6ebab96e3553615f8d03c384"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3c5f5100bfb06212b27b3fb485957c5e807d3704ce480fc1cc3aadca06fd48bc"
    sha256 cellar: :any,                 arm64_linux:       "980c6e505b5a35cd6fe39dcc931816501389bb75d61f5e5bf8e5414367d43f72"
    sha256 cellar: :any,                 x86_64_linux:      "af018b67dd7ebd2ba6047d21c81e7a4051315dcb4fa54dec067e7574e46179b5"
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
