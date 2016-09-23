class Gcovr < Formula
  desc "Reports from gcov test coverage program"
  homepage "http://gcovr.com/"
  url "https://github.com/gcovr/gcovr/archive/3.3.tar.gz"
  sha256 "8a60ba6242d67a58320e9e16630d80448ef6d5284fda5fb3eff927b63c8b04a2"
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
