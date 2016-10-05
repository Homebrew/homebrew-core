class GitSeries < Formula
  desc "Track changes to a patch series over time"
  homepage "https://github.com/git-series/git-series"
  url "https://github.com/git-series/git-series/archive/0.8.10.tar.gz"
  sha256 "d70c9a2105c69fdd6059c04285ddb74b3b10852d9729dd8a14681b9bf36790be"

  bottle do
    cellar :any
    sha256 "2daebeea29b8dab29cec91fc882c2b2d800b893e995d68ebfa76c00f45e25590" => :sierra
    sha256 "9e763fcdeca9dbe7e8033e19c8e58288a85ab01e9dbf887f53a87dd90f1746a3" => :el_capitan
    sha256 "4b9788b40b76dc4811b251ef8c08b654cefeae4fde5a8ef34e64bad52b4e0010" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "libssh2"

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/git-series"
    man1.install "git-series.1"
  end

  test do
    (testpath/".gitconfig").write <<-EOS.undent
    [user]
      name = Real Person
      email = notacat@hotmail.cat
    EOS

    system "git", "init"
    (testpath/"test").write "foo"
    system "git", "add", "test"
    system "git", "commit", "-m", "Initial commit"
    (testpath/"test").append_lines "bar"
    system "git", "commit", "-m", "Second commit", "test"
    system bin/"git-series", "start", "feature"
    system "git", "checkout", "HEAD~1"
    system bin/"git-series", "base", "HEAD"
    system bin/"git-series", "commit", "-a", "-m", "new feature v1"
  end
end
