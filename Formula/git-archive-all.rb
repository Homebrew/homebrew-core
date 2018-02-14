class GitArchiveAll < Formula
  desc "Archive a project and its submodules"
  homepage "https://github.com/Kentzo/git-archive-all"
  url "https://github.com/Kentzo/git-archive-all/archive/1.17.1.tar.gz"
  sha256 "c5fb6de7fd105dbe25cce7500e5d3032a5530467848c5b6464224e327a954de6"
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
