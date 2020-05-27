class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.5.11.tar.gz"
  sha256 "a46cad0ddff8b60ed54211b5bd156e3d33665eac7daa81a4b40da6ca06df06bc"

  bottle do
    cellar :any_skip_relocation
    sha256 "bece6ed104e83b954aea9ff1f53b07a47db784fb7186bad58bbf3fddb7d31f53" => :catalina
    sha256 "378c57b28ae62927a606c98c27d4522d557da855b9c6d7d5b0b7c6e7a150a616" => :mojave
    sha256 "0597d9bc68e34b942c8c28dcda6e28250b79c7030c58db4e32cf938f597248b5" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
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
