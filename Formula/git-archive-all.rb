class GitArchiveAll < Formula
  desc "Archive a project and its submodules"
  homepage "https://github.com/Kentzo/git-archive-all"
  url "https://github.com/Kentzo/git-archive-all/archive/1.17.tar.gz"
  sha256 "b07ab276811f643252ff03dd8cbb6706bd31311b0e0efa1499b864a32c835659"
  head "https://github.com/Kentzo/git-archive-all.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "55ff007d89ce553b6cae85f6e6c16639b5b5b8da08a17118a58dc06340cca5ce" => :high_sierra
    sha256 "55ff007d89ce553b6cae85f6e6c16639b5b5b8da08a17118a58dc06340cca5ce" => :sierra
    sha256 "55ff007d89ce553b6cae85f6e6c16639b5b5b8da08a17118a58dc06340cca5ce" => :el_capitan
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
                 shell_output("#{bin}/git-archive-all --dry-run ./archive", 0).chomp
  end
end
