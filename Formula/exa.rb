class Exa < Formula
  desc "Modern replacement for 'ls'"
  homepage "https://the.exa.website"
  url "https://github.com/ogham/exa/archive/v0.8.0.tar.gz"
  sha256 "07085fd784d553b7c3b62b5a52e4635580d6154f47e6d64245ec0588638dee3e"
  head "https://github.com/ogham/exa.git"

  bottle do
    sha256 "ae1ff39bfde4c8c26eac3a6e83b936941dfb8ec07c79520884a0e3a3563198fd" => :mojave
    sha256 "e10e5f5d86fbab6f6d558c620a73f1caf157d42c5a01c54636f2de08f4aaee4b" => :high_sierra
    sha256 "beb45a502b3e7a61689f14e298b310d83765c5242181ef0c7e12f72c8b7c7736" => :sierra
    sha256 "bf8070b4da1dbf25d8f7f12b324e845de5282dc5c028045af298cb41d2c30831" => :el_capitan
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
