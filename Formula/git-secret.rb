class GitSecret < Formula
  desc "Bash-tool to store the private data inside a git repo."
  homepage "https://sobolevn.github.io/git-secret/"
  url "https://github.com/sobolevn/git-secret/archive/v0.2.0.tar.gz"
  sha256 "db4afbc3a453df2527603bf8bfffd9946f00d5595f2dca4f5088cb6bb47cacdf"
  head "https://github.com/sobolevn/git-secret.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9844a5567d90039e43c24228d50cfe033aefd1196bfdc30b6a7986bc6cf4581d" => :el_capitan
    sha256 "57f69c45ca7d665f9a6610d4212530f946ad8effbd1f806280b3f98f2e880ee8" => :yosemite
    sha256 "620a145f092f79a5109f2f61f555f0d2319344b8c60d09639da37b1813ce592a" => :mavericks
  end

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
