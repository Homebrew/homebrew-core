class GitSecrets < Formula
  desc "Prevents you from committing sensitive information to a git repo"
  homepage "https://github.com/awslabs/git-secrets"
  url "https://github.com/awslabs/git-secrets/archive/1.2.1.tar.gz"
  sha256 "9899907609b227e495725af7cf094cf9e09a8d732945db24ef5558fd0d6ad5ef"
  head "https://github.com/awslabs/git-secrets.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7f79f00cb9a0e513e87dc5d9c530c65cf67a3f8fbb6033ed5bdbb7567983a90f" => :mojave
    sha256 "77439a0901cb4fd611a627f2c484f10a0e11676755d055807d441d6a674b7d91" => :high_sierra
    sha256 "19f150d26c9b84cbecfc64b6659b35cac4cb331ed1b22d43937e466657c5b4e0" => :sierra
    sha256 "6a6f3422972f01a5372517fb4a904ace978f1887613c9e453e51b5add7842d22" => :el_capitan
    sha256 "ce6027006ba7006afc654a793a79efaeba33ea1b858e062fff5993249ac89d6c" => :yosemite
    sha256 "aa6f20339c958f734ef7b9dd6a19e6972ba256561fb34992353111ea3f8a0b45" => :mavericks
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "git", "init"
    system "git", "secrets", "--install"
  end
end
