class BzrRewrite < Formula
  desc "Bazaar plugin to support rewriting revisions and rebasing"
  homepage "https://launchpad.net/bzr-rewrite"
  url "https://launchpad.net/bzr-rewrite/trunk/0.6.3/+download/bzr-rewrite-0.6.3.tar.gz"
  sha256 "f4d0032a41a549a0bc3ac4248cd4599da859174ea33e56befcb095dd2c930794"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "766e43ea10eb6eae8ed9f177faa70b7e8f26be6d79367a060775da9e247b6d4c"
  end

  disable! date: "2022-10-19", because: :unsupported

  depends_on "bazaar"

  def install
    (share/"bazaar/plugins/rewrite").install Dir["*"]
  end

  test do
    file_path1 = testpath/"foo/trunk/file1.txt"
    file_path2 = testpath/"foo/b1/file2.txt"

    system "bzr", "whoami", "Homebrew"
    system "bzr", "init-repo", "foo"

    cd "foo" do
      system "bzr", "init", "trunk"
      cd "trunk" do
        file_path1.write "change"
        system "bzr", "add"
        system "bzr", "commit", "-m", "trunk 1"
      end

      system "bzr", "branch", "trunk", "b1"
      cd "b1" do
        file_path2.write "change"
        system "bzr", "add"
        system "bzr", "commit", "-m", "branch 1"

        file_path2.append_lines "change"
        system "bzr", "commit", "-m", "branch 2"
      end

      cd "trunk" do
        file_path1.append_lines "change"
        system "bzr", "commit", "-m", "trunk 2"

        file_path1.append_lines "change"
        system "bzr", "commit", "-m", "trunk 3"
      end

      cd "b1" do
        system "bzr", "rebase", "../trunk"

        assert_match(/branch 2/, shell_output("bzr log -r5"))
        assert_match(/branch 1/, shell_output("bzr log -r4"))
        assert_match(/trunk 3/,  shell_output("bzr log -r3"))
        assert_match(/trunk 2/,  shell_output("bzr log -r2"))
        assert_match(/trunk 1/,  shell_output("bzr log -r1"))
      end
    end
  end
end
