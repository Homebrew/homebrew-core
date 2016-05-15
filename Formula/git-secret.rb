class GitSecret < Formula
  desc "Bash-tool to store the private data inside a git repo."
  homepage "https://sobolevn.github.io/git-secret/"
  url "https://github.com/sobolevn/git-secret/archive/v0.1.2.tar.gz"
  sha256 "96032c1c0b2b161c4df5b8627be8d98a97a92a5d32127c9a5e8686bd64b5a3e7"
  head "https://github.com/sobolevn/git-secret.git"

  depends_on :gpg => :recommended

  def install
    system "make", "build"
    system "bash", "utils/install.sh", prefix
  end

  test do
    system "git", "init"
    system "git", "secret", "init"
  end
end
