class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.7.2.tar.gz"
  sha256 "85c2992bc0c24940842db8006aca8d0ae5f487a60133212066d5da57bdde6ea2"
  license "CC0-1.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "d83309b390fe2d2d1acd16e86ccd749294f01c97ea36222173699f67dc31b43f" => :catalina
    sha256 "879780f167d022a78c3eda09921f90cb6a69fe81900bcc72266afc1de2a4570b" => :mojave
    sha256 "b94c01db3ac8a7020fa5ac368c3fb72f4c00a420efe6a36669b640dc3268dc7f" => :high_sierra
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
