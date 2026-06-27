class MozGitTools < Formula
  desc "Tools for working with Git at Mozilla"
  homepage "https://github.com/mozilla/moz-git-tools"
  url "https://github.com/mozilla/moz-git-tools/archive/refs/tags/v0.1.tar.gz"
  sha256 "defb5c369ff94f72d272692282404044fa21aa616487bcb4d26e51635c3bc188"
  license all_of: ["GPL-2.0-only", "CC0-1.0"]
  head "https://github.com/mozilla/moz-git-tools.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "fe6165fdfda101ce38db57eb7352acf2fd00e96edef8eceef8fe30565cc07da1"
  end

  deprecate! date: "2024-08-01", because: :repo_archived
  disable! date: "2025-08-03", because: :repo_archived

  def install
    # Install all the executables, except git-root since that conflicts with git-extras
    bin_array = Dir.glob("git*").push("hg-patch-to-git-patch")
    bin_array.delete("git-root")
    bin_array.delete("git-bz-moz") # a directory, not an executable
    bin_array.each { |e| bin.install e }
  end

  def caveats
    <<~EOS
      git-root was not installed because it conflicts with the version provided by git-extras.
    EOS
  end

  test do
    # create a Git repo and check its branchname
    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS

    system "git", "init", "--initial-branch=main"
    (testpath/"myfile").write("# BrewTest")
    system "git", "add", "myfile"
    system "git", "commit", "-m", "test"
    assert_match "main", shell_output("#{bin}/git-branchname")
  end
end
