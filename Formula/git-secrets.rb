class GitSecrets < Formula
  desc "Prevents you from committing sensitive information to a git repo"
  homepage "https://github.com/awslabs/git-secrets"
  url "https://github.com/awslabs/git-secrets/archive/1.2.0.tar.gz"
  sha256 "bb6d9b5a0ffd74b0533e47eee51d5cdf6e0068cd2e066b8bb5df229821bce497"

  head "https://github.com/awslabs/git-secrets.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "eeac8757b5717c09b9e1590ed25bb85ad7406d74c1c2db7e5d71fc91141de39b" => :el_capitan
    sha256 "1df153cdf8f4ddcd2772af614bcd34b7bfd4e0058019f076796d86313f43d481" => :yosemite
    sha256 "e528aacc7961e37e9aedb3f4e9eab47126863419fea69c99ea7e99eb627d8dd7" => :mavericks
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "git", "init"
    system "git", "secrets", "--install"
  end
end
