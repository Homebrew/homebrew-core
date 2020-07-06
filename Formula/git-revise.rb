class GitRevise < Formula
  include Language::Python::Virtualenv

  desc "Rebase alternative for easy & efficient in-memory rebases and fixups"
  homepage "https://github.com/mystor/git-revise"
  url "https://github.com/mystor/git-revise/archive/v0.6.0.tar.gz"
  sha256 "99c3804ddb73f1115bd6be05d10e640a7066e4019c6c223433e55136e66fa4c8"
  license "MIT"
  head "https://github.com/mystor/git-revise.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "644bd8885dfc27b0cb84294b7195a296b1c1d56af5b870db7af109a93d80e2a0" => :catalina
    sha256 "a9a61b083fc459b407488d8ef7e2439059702e89eaa19c9a5a8c0e1fb8f1a7c7" => :mojave
    sha256 "1d15213e6e0220d5e97dd8991b4545d0789a3b907fff1a0996255ea675a1a94b" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
    man1.install "git-revise.1"
  end

  test do
    (testpath/".gitconfig").write <<~EOS
      [user]
        name = J. Random Tester
        email = test@example.com
    EOS
    system "git", "init"
    (testpath/"test").write "foo"
    system "git", "add", "test"
    system "git", "commit", "--message", "a bad message"
    system "git", "revise", "--message", "a good message", "HEAD"
    assert_match "a good message", shell_output("git log --format=%B -n 1 HEAD")
  end
end
