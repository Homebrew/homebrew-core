class GitOctopus < Formula
  desc "Extends git-merge with branch naming patterns"
  homepage "https://github.com/lesfurets/git-octopus"
  url "https://github.com/lesfurets/git-octopus/archive/v1.2.1.tar.gz"
  sha256 "eb289838aa9acbb9c81bed23dbd98aeada5e7ab5bbd914fdd7a5d4a92b53891d"

  bottle do
    cellar :any_skip_relocation
    sha256 "aac9cf0672d53ceb8afc7b12dd716b4e60e6be60968e3e1107334f8e4bebefff" => :el_capitan
    sha256 "4752688d5d0cf4c2d6c848ef329ecda42fc20e4ad5f35b58089d306d823a277a" => :yosemite
    sha256 "0171f6434810012312ba6df32f26485dd55fc0f4a60dbf68a4b4ccbc04afae58" => :mavericks
  end

  def install
    system "make", "build"
    bin.install "bin/git-octopus", "bin/git-conflict", "bin/git-apply-conflict-resolution"
    man1.install "doc/git-octopus.1", "doc/git-conflict.1"
  end

  test do
    (testpath/".gitconfig").write <<-EOS.undent
      [user]
        name = Real Person
        email = notacat@hotmail.cat
      EOS
    system "git", "init"
    touch "homebrew"
    system "git", "add", "."
    system "git", "commit", "--message", "brewing"

    assert_equal "", shell_output("#{bin}/git-octopus 2>&1", 0).strip
  end
end
