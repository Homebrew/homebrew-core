class GitSecrets < Formula
  desc "Prevents you from committing sensitive information to a git repo"
  homepage "https://github.com/awslabs/git-secrets"
  url "https://github.com/awslabs/git-secrets/archive/1.1.0.tar.gz"
  sha256 "30c6a51851487776bc976792c7dd472725c878c2e92710c898afbcc33cd02cbb"

  head "https://github.com/awslabs/git-secrets.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "507203d830baf99ad264ed775143492d99220bc2cb39272470d5998d42688e8c" => :el_capitan
    sha256 "3fb2a6920274a25f798cc63634fe761e84b0dd95cadc8a6002f5046de0f409a6" => :yosemite
    sha256 "3f029daa78fdf93face499e6ea811c06dc5f7d4a8faa79ac8759fd4d84a4be9d" => :mavericks
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "git", "init"
    system "git", "secrets", "--install"
  end
end
