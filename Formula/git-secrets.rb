class GitSecrets < Formula
  desc "Prevents you from committing sensitive information to a git repo"
  homepage "https://github.com/awslabs/git-secrets"
  url "https://github.com/awslabs/git-secrets/archive/1.3.0.tar.gz"
  sha256 "f1d50c6c5c7564f460ff8d279081879914abe920415c2923934c1f1d1fac3606"
  head "https://github.com/awslabs/git-secrets.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "92ae3c8447754b1f5d23b5e7e3a601fca133f4b691b51b5004ffe17f4d763622" => :catalina
    sha256 "d77761ee552d2963788f2bcab6c695d1b52f9d0c1d68dad65230901c750e63aa" => :mojave
    sha256 "d77761ee552d2963788f2bcab6c695d1b52f9d0c1d68dad65230901c750e63aa" => :high_sierra
    sha256 "fc2745b24be00e6b8e4b82d6768632810823ffff3f80ad99ca9943b31d003003" => :sierra
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "git", "init"
    system "git", "secrets", "--install"
  end
end
