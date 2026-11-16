class Drydock < Formula
  desc "Dashboard for a fleet of Git repositories"
  homepage "https://github.com/yetidevworks/drydock"
  url "https://github.com/yetidevworks/drydock/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "36aac94ee78b552de65c1574d52f63271ad97c75ef9ba7fecff4db5d5481e90f"
  license "MIT"
  head "https://github.com/yetidevworks/drydock.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9b5879c03abd28913b21b56e71f495e5d032ae70798c9538a75e902d8dad08f7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fbd773358d38766b4d5515c3c8f5a85525d4b518adc6631abe54d24479224a8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d9fa729648aa158e3ee9600fb46aa34dbe1092cd0f4a945649f63c561b9d196b"
    sha256 cellar: :any,                 arm64_linux:       "c865486bb0a2e5db461458e0847eed6d8a06b980f5ac35dfc5a4f785b1264d1a"
    sha256 cellar: :any,                 x86_64_linux:      "f680cfc3def6cf40149fff013613f5940bf2220c0a9684d46d9d22b986b34c1c"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/drydock")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/drydock --version")

    output = shell_output("#{bin}/drydock config show")
    assert_match 'roots = ["~/Projects"]', output
  end
end
