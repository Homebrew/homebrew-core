class Fend < Formula
  desc "Arbitrary-precision unit-aware calculator"
  homepage "https://printfn.github.io/fend"
  url "https://github.com/printfn/fend/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "787a9ffc2de1f9544bb82eaa430800c63da12a1518801c5e150d73feacf81b68"
  license "MIT"
  head "https://github.com/printfn/fend.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "782eb867bf6e4310b7336b26cd914f0f13838813def4942fd963fc8070ec7d43"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3f2db8a14af9cf80424446deb3d48a777a659ba48fd4f7deba0f5ecc1a1acb4"
    sha256 cellar: :any_skip_relocation, monterey:       "d6e422fc9120dbc6f495529122ee6bd64407d20b137698318688370ccbf9961c"
    sha256 cellar: :any_skip_relocation, big_sur:        "199dce759434008dd0254a1cdad93c754597e269f89fd885fab8fea6c4bac629"
    sha256 cellar: :any_skip_relocation, catalina:       "ea5827ed6e5a3073d0acb1493dfe6f47280b49990db0ae5609a3776052a48ada"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cad0e7ccfbb23016218b1f41010a836014c5ce027017ef6734bc00b8a2a1343c"
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
