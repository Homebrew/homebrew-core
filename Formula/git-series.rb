class GitSeries < Formula
  desc "Track changes to a patch series over time"
  homepage "https://github.com/git-series/git-series"
  url "https://github.com/git-series/git-series/archive/0.8.11.tar.gz"
  sha256 "d884e77c03304ba77cac3845b5e51a7856d517771db72c652f53b47cbaa13890"

  bottle do
    cellar :any
    sha256 "2ba7be3922b6ef0e3fb615ab03ee71732139085172cb64033cec1528dc8cc423" => :sierra
    sha256 "c6c0bcd6f2fe3f07204a568c5b9a3d258e6c78233aa718f134bda32547b8fdb0" => :el_capitan
    sha256 "d2999d4f44f0c43d9761456500f333ea8e44d5c09bd8d48932efd47da20662e2" => :yosemite
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
