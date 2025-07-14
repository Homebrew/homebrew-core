class GitSecrets < Formula
  desc "Prevents you from committing sensitive information to a git repo"
  homepage "https://github.com/awslabs/git-secrets"
  license "Apache-2.0"
  head "https://github.com/awslabs/git-secrets.git", branch: "master"

  stable do
    url "https://github.com/awslabs/git-secrets/archive/refs/tags/1.3.0.tar.gz"
    sha256 "f1d50c6c5c7564f460ff8d279081879914abe920415c2923934c1f1d1fac3606"

    # Backport removal of unnecessary dependency on `say`
    patch do
      url "https://github.com/awslabs/git-secrets/commit/65891e23f341f159098300999edcce5983cd3ad8.patch?full_index=1"
      sha256 "add9ad9f5778dd38885a23b8b394601061a203d1862b91cd64c5ca2a0c9a6ab2"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "826637bd7920ad23df848a7ffbfadb79a7d7c918b330d80bc7fea4dfb9fed1d5"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "git", "init"
    system "git", "secrets", "--install"
  end
end
