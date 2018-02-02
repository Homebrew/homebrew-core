class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.3.7.tar.gz"
  sha256 "f69ad9cbd0867ba294dd25b3421a4b0b79f475d907f17a3bf8e9f20c7f7304f7"

  bottle do
    sha256 "ebe9783bac54e3a83b6748c615675073a3c22539d573cf76bbb69e4c58ace88c" => :high_sierra
    sha256 "44230a55bfc5eb141be484d18a7b7fe71686b4ee9c0b17349fec0c78cfc983d4" => :sierra
    sha256 "72cf299d78a8bfea783133eb548a3bd74244395797907613e7b731a01a01ec88" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/just"
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
