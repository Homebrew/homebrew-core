class Erdtree < Formula
  desc "Multi-threaded file-tree visualizer and disk usage analyzer"
  homepage "https://github.com/solidiquis/erdtree"
  url "https://github.com/solidiquis/erdtree/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "8bf5693e3649def61c3bc12f42a3a019647c4efda4bbaafb13a7bf84de67d668"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d76db0664770eb6cc016d6ddc8ec784648596ef70ed52b0bae57abbadbe42741"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "082bd6583b122e4270309266be875f0085e7a1c0fb2de68e7e833506f7e2d7ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4e04a01af1c1da307f8b65a0c0b5fa13b5074b75b638b858b50861d35f18b97"
    sha256 cellar: :any_skip_relocation, ventura:        "4f166378d2516395e1e961c60eac47ab6ffdde60ccccf5f9ea35d4a20a4f8d6c"
    sha256 cellar: :any_skip_relocation, monterey:       "74230c9d4e5a2daccf6ffa798d516ad099c00fed7ccd446d2d938f09f31579f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad5a5102671fe21287e00ae82eeb638b25cde2865865484bdd4178fa6b25ee0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "382e99cc2391f6b74a83aea5bb909bd29427305fed44bebf110ec09e2f7c462a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch "test.txt"
    assert_match "test.txt", shell_output("#{bin}/et")
  end
end
