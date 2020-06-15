class Jvgrep < Formula
  desc "Grep for Japanese users of Vim"
  homepage "https://github.com/mattn/jvgrep"
  url "https://github.com/mattn/jvgrep/archive/v5.8.8.tar.gz"
  sha256 "dc3b5f77189bf8f91d7c8f48e3908dcf4dfea9fd12cd23e71deb54e3ea64d724"
  head "https://github.com/mattn/jvgrep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d1060a9bafbdaa653573e89cacc6df443f72368cf1314398a11e4509203604bc" => :catalina
    sha256 "d1060a9bafbdaa653573e89cacc6df443f72368cf1314398a11e4509203604bc" => :mojave
    sha256 "d1060a9bafbdaa653573e89cacc6df443f72368cf1314398a11e4509203604bc" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system bin/"jvgrep", "Hello World!", testpath
  end
end
