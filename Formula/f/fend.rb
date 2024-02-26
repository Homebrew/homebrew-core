class Fend < Formula
  desc "Arbitrary-precision unit-aware calculator"
  homepage "https://printfn.github.io/fend"
  url "https://github.com/printfn/fend/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "6ff204f937bcdb58e29ed2f076efa82aa323e39ab615c4ce87b5358e2237edc2"
  license "GPL-3.0-or-later"
  head "https://github.com/printfn/fend.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a26398dc1e80b10668fc4933f0855f01cfd90081de856d3151868f93c3d78e4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6197a40831b264c4e22098c4e5abc05fa1746ba320bc9f7e45f486f2e1610e39"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed9afcdc9c22b26218de83974830231d25b444560d5cff936039898b540b3ee7"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b508909164a947e390bb51ea750ad7f44e20af4d626586dfabe090df486e2a9"
    sha256 cellar: :any_skip_relocation, ventura:        "790d593cbec6a66d1c151912d915941d19e29cb6e0a6245de7870aaed6ab1535"
    sha256 cellar: :any_skip_relocation, monterey:       "2b42b4775563f6c2c8b66cdae464f54cf45b2df7455cd190c7653162f4aee1cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fffb21cecbdeb5119e3b01c594db5da1d9132cee8bf6043efbb9de1e978dc0b"
  end

  depends_on "pandoc" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    system "./documentation/build.sh"
    man1.install "documentation/fend.1"
  end

  test do
    assert_equal "1000 m", shell_output("#{bin}/fend 1 km to m").strip
  end
end
