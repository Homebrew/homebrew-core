class GitSeries < Formula
  desc "Track changes to a patch series over time"
  homepage "https://github.com/git-series/git-series"
  url "https://github.com/git-series/git-series/archive/0.8.10.tar.gz"
  sha256 "d70c9a2105c69fdd6059c04285ddb74b3b10852d9729dd8a14681b9bf36790be"

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
