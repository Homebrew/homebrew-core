class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/1.12.0.tar.gz"
  sha256 "f2359040c02392bcc11c9a1ca13fef8089e509cb64eb342e20c96f9edd5c1e55"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eac6da8fc39c119a6dc44a3b425b748df81376aa12db27b4a66d594376bf4272"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3578e677b6147893a512df7f5451e8d1d7bcbb536beb6fcda64bf1e7eab27ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cce41c0961f7995052c9469041233dbe25ef729432533b42db9760428eca7b9e"
    sha256 cellar: :any_skip_relocation, ventura:        "b2347dd0df10baa8475c7aaf1cd8ed2fbf9fc91747a77ca18df831078e275aa0"
    sha256 cellar: :any_skip_relocation, monterey:       "56d19653bb438ffbd14e357d37e367ff73950897a7d61d63411086dd9aa9cd18"
    sha256 cellar: :any_skip_relocation, big_sur:        "084a9948a15a7d2d7e10b906d14414090e446960dce70ccdd474c78fbdd6e834"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4595200adfd88d7e2f5b60bf9c2f5a93b9c8d9cd96620f654257deb239010769"
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
