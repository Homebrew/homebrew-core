class Nmstatectl < Formula
  desc "Command-line tool that manages host networking settings in a declarative manner"
  homepage "https://nmstate.io/"
  url "https://github.com/nmstate/nmstate/releases/download/v2.2.62/nmstate-2.2.62.tar.gz"
  sha256 "37564cf14526037befcc919b72a715427ba3cb029e7d2de41f15b00268febc23"
  license "Apache-2.0"
  head "https://github.com/nmstate/nmstate.git", branch: "base"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9d7f2e25f60804ff0d78eeadb6ecf08047b37b78f967322853ecd40979878930"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "81088a27fb9ed3af1e7d6effd199fd0278e273099dd32e3f91feabf209db3116"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "71f31e26ab6bed154e8033249fec867f178253aeeaef4e28eac1aaca4ebfa54f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "b029458fcfa738f0c8c96ed54612eee45a38ae1a398c52da6d69e1091690fff8"
    sha256 cellar: :any_skip_relocation, sonoma:            "addfbc4ec8716027ec199eba6616504169149bce55195cb87b652b49908a8288"
    sha256 cellar: :any,                 arm64_linux:       "2ff072c171d32d590be4005da838753c22c57e68f1368ed973e8254b90283618"
    sha256 cellar: :any,                 x86_64_linux:      "385dfe65643c96fd55b170d0b217971dbacec78758f7b19d8cfb83288183bc55"
  end

  depends_on "rust" => :build

  def install
    cd "rust" do
      if OS.mac?
        args = ["--no-default-features"]
        features = ["gen_conf"]
      end
      system "cargo", "install", *args, *std_cargo_args(path: "src/cli", features:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nmstatectl --version")

    assert_match "interfaces: []", pipe_output("#{bin}/nmstatectl format", "{}", 0)
  end
end
