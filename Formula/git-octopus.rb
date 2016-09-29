class GitOctopus < Formula
  desc "The continuous merge workflow"
  homepage "https://github.com/lesfurets/git-octopus"
  url "https://github.com/lesfurets/git-octopus/archive/v1.3.tar.gz"
  sha256 "f4d150c840189053fd327a5141361369b6ed80d57a6bbdd84e9d035777c87b0a"

  bottle do
    cellar :any_skip_relocation
    sha256 "8d92590bd06f936d99543443d1ab8a12132b7272077663bef6a4c732c7de8610" => :sierra
    sha256 "e2d7d62cced676ad6201170d71bb219514c6761e4753b35ca73f959eb4604937" => :el_capitan
    sha256 "85ca8acf1dbe1c83b879982472895b41e19c00ff435ac7729b3b18a8a5af4c1e" => :yosemite
    sha256 "ae0533d3543c79194a482c66a41c768bfa94a6253789ca98f259e6c4c7e965e2" => :mavericks
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
