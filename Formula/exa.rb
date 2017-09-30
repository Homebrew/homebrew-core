class Exa < Formula
  desc "Modern replacement for 'ls'"
  homepage "https://the.exa.website"
  url "https://github.com/ogham/exa/archive/v0.8.0.tar.gz"
  sha256 "07085fd784d553b7c3b62b5a52e4635580d6154f47e6d64245ec0588638dee3e"
  head "https://github.com/ogham/exa.git"

  bottle do
    rebuild 1
    sha256 "db4b31c636e12fc7ec144a78e75982cbf7bd1055421e780478b614138e6b07d4" => :high_sierra
    sha256 "38df071abb28b604ccfac40d7252828c410bacd256e95d7f853940333d603b83" => :sierra
    sha256 "d2e08a87b7a7b81ab1f4a03f3d89381beea29c2dcc2ebbee3060336fe2863df5" => :el_capitan
  end

  option "without-git", "Build without Git support"

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    args = ["PREFIX=#{prefix}"]
    args << "FEATURES=" if build.without? "git"

    system "make", "install", *args
    bash_completion.install "contrib/completions.bash" => "exa"
    zsh_completion.install  "contrib/completions.zsh"  => "_exa"
    fish_completion.install "contrib/completions.fish" => "exa.fish"
  end

  test do
    (testpath/"test.txt").write("")
    assert_match "test.txt", shell_output("#{bin}/exa")
  end
end
