class GitSeries < Formula
  desc "Track changes to a patch series over time"
  homepage "https://github.com/git-series/git-series"
  url "https://github.com/git-series/git-series/archive/0.9.1.tar.gz"
  sha256 "c0362e19d3fa168a7cb0e260fcdecfe070853b163c9f2dfd2ad8213289bc7e5f"

  bottle do
    cellar :any
    sha256 "011a866094f523161e8d153da782acde646e59f92def690dfbb2298529e38492" => :sierra
    sha256 "4ee103a2d1645bf3e214c81d6fe34736217c3b0394dcb4881b16e348c71c1e62" => :el_capitan
    sha256 "ef5a67c986fca412080678bd81a8791e3af5739ba5236f38aa79b99a33aa8a41" => :yosemite
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
