class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/1.1.1.tar.gz"
  sha256 "b985def8260965773422fc6c665fa37aeb7304280560dbf8f641479ba00e2da0"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "694b5a1495219d2431578cf49a113b7369d1539b5b13819e0fd15f2b4876d053"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93a97780be6ed8bd197f338f98a0a4206745cff15c3585c1c84824b12b8a3dcc"
    sha256 cellar: :any_skip_relocation, monterey:       "c3a1e0ceeb5e7d20a466d4ae05df0a47bf8e9377d64fa63e34928128f0baed2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f0618f8981218ee756eb5d421ee28ebf66a4a0578174b76f06d28424f6ec49d"
    sha256 cellar: :any_skip_relocation, catalina:       "799f1f8360049494c84c324ad9e4ad0401e482dcdc90cc7a5ffa70320ac3f93c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68c5773af9a8ac6b3d5106e7a5ec818005c23266f1210ce4858f0211a1e04845"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "man/just.1"
    bash_completion.install "completions/just.bash" => "just"
    fish_completion.install "completions/just.fish"
    zsh_completion.install "completions/just.zsh" => "_just"
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system bin/"just"
    assert_predicate testpath/"it-worked", :exist?
  end
end
