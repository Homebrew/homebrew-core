class GitArchiveAll < Formula
  desc "Archive a project and its submodules"
  homepage "https://github.com/Kentzo/git-archive-all"
  url "https://github.com/Kentzo/git-archive-all/archive/1.19.4.tar.gz"
  sha256 "00acfe0324862daaa01146d24b20337416318382d36be88c208a8f7576191d2b"
  head "https://github.com/Kentzo/git-archive-all.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0897316f38dad6e50cc409e45cb3e6dbe04a9be236b95762dccd0f4c1d2d14e1" => :mojave
    sha256 "963bb86e6c3829d50bcd052d32a85038d816414ebbdb1c76fade74041278820d" => :high_sierra
    sha256 "963bb86e6c3829d50bcd052d32a85038d816414ebbdb1c76fade74041278820d" => :sierra
  end

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS
    system "git", "init"
    touch "homebrew"
    system "git", "add", "homebrew"
    system "git", "commit", "--message", "brewing"

    assert_equal "#{testpath.realpath}/homebrew => archive/homebrew",
                 shell_output("#{bin}/git-archive-all --dry-run ./archive").chomp
  end
end
