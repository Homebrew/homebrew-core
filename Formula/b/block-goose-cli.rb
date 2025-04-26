class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://github.com/block/goose/archive/refs/tags/v1.0.20.tar.gz"
  sha256 "011e084b76abdcf30c7f77b8043167b741f30894e11fc527e8ec98efd53427db"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f79f80490d4702af124405568534594a16ee1aad928a1e7ac31c391f59f8c5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9888ddc19e5fe7893e693f41e1e1974110f81852e32e9b9eb28da5d560b5f787"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f9947bf27ef62b09640d056f2b5bd9044e72684016eb54715680b0fe84a818b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "c02430a2e0a1f1d4e10115042a4a33ecb8f232c55c1b15043b9bb6061d3a5647"
    sha256 cellar: :any_skip_relocation, ventura:       "c2e57354a1a315dd567bd61fcd1110e39f3883861a775f63251f03b2865c6211"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46e32458d9647a77e9783667f48fa467fa38f03a5f56b93f57b653ebae95760a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "481144235a41208598e6fa327e187c39786edd2102de8bdb716a4ffa02dd52fb"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "dbus"
    depends_on "libxcb"
  end

  conflicts_with "goose", because: "both install `goose` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/goose-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version")
    assert_match "Goose Locations", shell_output("#{bin}/goose info")
  end
end
