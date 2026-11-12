class GridcraftCli < Formula
  desc "Headless GridCraft CLI and MCP server to inspect, convert and script workbooks"
  homepage "https://getartcraft.com/apps/gridcraft"
  url "https://github.com/storytold/gridcraft/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "35d684c47cafacb4c28e02440efcda796d44c561df26410037661a8fe655e42d"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/gridcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "05b4768895879d6927f857a38853a5171d04710a522a79df9e1a5738c0976937"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "87c763a924000d5e40b313264da534978299387a5dd5128cdc9efea5f3c153f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ecb7d7769a60fa72cca29380c874154a3d7769838030d864b312b9f47388949c"
    sha256 cellar: :any,                 arm64_linux:       "5c01518b5fe31c6d60f839fb032fecde00f3e43e56c0b75fa6dbfe99d52cfa3f"
    sha256 cellar: :any,                 x86_64_linux:      "7537921ff9d27c76f0a55a5afd254aaa12c4a75c50ee7ae5b71c7e92a2f47814"
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
