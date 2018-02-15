class Gcovr < Formula
  desc "Reports from gcov test coverage program"
  homepage "https://gcovr.com/"
  url "https://github.com/gcovr/gcovr/archive/3.4.tar.gz"
  sha256 "1c52a71f245adfe1b45e30fbe5015337fe66546f17f40038b3969b7b42acceed"
  head "https://github.com/gcovr/gcovr.git"

  bottle :unneeded

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"scripts/gcovr"
  end

  test do
    (testpath/"example.c").write "int main() { return 0; }"
    system "cc", "-fprofile-arcs", "-ftest-coverage", "-fPIC", "-O0", "-o",
                 "example", "example.c"
    assert_match "Code Coverage Report", shell_output("#{bin}/gcovr -r .")
  end
end
