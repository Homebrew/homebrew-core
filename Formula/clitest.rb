class Clitest < Formula
  desc "Command-Line Tester"
  homepage "https://github.com/aureliojargas/clitest"
  url "https://github.com/aureliojargas/clitest/archive/refs/tags/0.4.0.tar.gz"
  sha256 "e889fb1fdaae44f0911461cc74849ffefb1fef9b200584e1749b355e4f9a3997"
  license "MIT"
  head "https://github.com/aureliojargas/clitest.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b9badcbac8548cafe8e0eadb7ec8b90a48c52d97ae1d437c068edd950476d647"
  end

  def install
    bin.install "clitest"
  end

  test do
    (testpath/"test.txt").write <<~EOS
      $ echo "Hello World"   #=> Hello World
      $ cd /tmp
      $ pwd                  #=> /tmp
      $ cd "$OLDPWD"
      $
    EOS
    assert_match "OK: 4 of 4 tests passed",
      shell_output("#{bin}/clitest #{testpath}/test.txt")
  end
end
