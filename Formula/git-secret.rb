class GitSecret < Formula
  desc "Bash-tool to store the private data inside a git repo."
  homepage "https://sobolevn.github.io/git-secret/"
  url "https://github.com/sobolevn/git-secret/archive/v0.2.1.tar.gz"
  sha256 "6088c1a149702f6e73b0c40e952c5ece35dbeb3cf5f595e93e16306b1cea32a4"
  revision 1

  head "https://github.com/sobolevn/git-secret.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ea7e2b5f4421aa058b8ee3f37ea9dd6bbaa51e04a4f509fb700d94dfec89028b" => :sierra
    sha256 "11f99b9a00368b61b702d8721dd5e3912313193049a774122d0d47821b084e74" => :el_capitan
    sha256 "d5031333baeed0aeb462697201830c5b322f32bdedcda34fd0bf79956806b572" => :yosemite
    sha256 "f6a410b125f8bed9125e6fe2c6fb741353725860c023665e272e8d57e28be245" => :mavericks
  end

  depends_on :gpg => :recommended

  def install
    system "make", "build"
    system "bash", "utils/install.sh", prefix
  end

  test do
    Gpg.create_test_key(testpath)
    system "git", "init"
    system "git", "config", "user.email", "testing@foo.bar"
    system "git", "secret", "init"
    assert_match "testing@foo.bar added", shell_output("git secret tell -m")
    (testpath/"shh.txt").write "Top Secret"
    (testpath/".gitignore").write "shh.txt"
    system "git", "secret", "add", "shh.txt"
    system "git", "secret", "hide"
    assert File.exist?("shh.txt.secret")
  end
end
