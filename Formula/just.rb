class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.6.0.tar.gz"
  sha256 "412a8c98537022909600968b1458af9f13e51372bad2c6816cb26a1704387c90"

  bottle do
    cellar :any_skip_relocation
    sha256 "8cb2a02e43fec830443f1c7977ad03c6e185e252954798b12bcb75ae471fc541" => :catalina
    sha256 "b4d6d871021492547ce3d103153585e895baa570aba96c320c75e97f0469ac75" => :mojave
    sha256 "18e75c45d09cadec94bb31900b480f07163da458f3876839725bc2b9b8c22212" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system "#{bin}/just"
    assert_predicate testpath/"it-worked", :exist?
  end
end
