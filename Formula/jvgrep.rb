class Jvgrep < Formula
  desc "Grep for Japanese users of Vim"
  homepage "https://github.com/mattn/jvgrep"
  url "https://github.com/mattn/jvgrep/archive/v5.8.5.tar.gz"
  sha256 "82470a9852b5cb2f093bcdbcb7c66f3d2e1ab7a8f3680e90d6944a0990a11f3d"
  head "https://github.com/mattn/jvgrep.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e3185aabdad286cf8e9879a2ba383c55c65daa00cd6b3579f94b0cf42240cd51" => :catalina
    sha256 "e3185aabdad286cf8e9879a2ba383c55c65daa00cd6b3579f94b0cf42240cd51" => :mojave
    sha256 "e3185aabdad286cf8e9879a2ba383c55c65daa00cd6b3579f94b0cf42240cd51" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"jvgrep"
    prefix.install_metafiles
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system bin/"jvgrep", "Hello World!", testpath
  end
end
