class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/1.13.0.tar.gz"
  sha256 "ead24ef982253fa4bdd0af27b0867f74c8d9528817be8dd8b14b182369a432c7"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7eeddde74d44f990c78f443e09f5e750601a962d690dedbb03d280daf13f5fd5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9db34d2a056b4adbceaf1f2d78eda9461d6cec434b3d68c23b41aa84ab8863c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab86ec865b3565d92affdda397666706dfc9e183054a2bfa13be57373889483e"
    sha256 cellar: :any_skip_relocation, ventura:        "91cd31b4132a9fd4081bfdc09171e0f9dabd2e68fcb145500ea2ef9f87b3774e"
    sha256 cellar: :any_skip_relocation, monterey:       "600b5a4458ca7403eb26082580e2d76625f50836530f3733f144ed293a5928a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "54a0ee36fcb17a1d23682122ebab6e63667cd1741d4abbaab01a61f8518ced74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d341280d16b3adafebf954af28274b5d76b148efbeb422964c9916960662861"
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
