class GitRevise < Formula
  include Language::Python::Virtualenv

  desc "Rebase alternative for easy & efficient in-memory rebases and fixups"
  homepage "https://github.com/mystor/git-revise"
  url "https://files.pythonhosted.org/packages/8e/80/97eae3a7d93f8c17127ac5722ffb5a0f3b3bfd18525569865d2bfb5d27a1/git-revise-0.6.0.tar.gz"
  sha256 "21e89eba6602e8bea38b34ac6ec747acba2aee876f2e73ca0472476109e82bf4"
  license "MIT"
  revision 1
  head "https://github.com/mystor/git-revise.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "ba6785e053fa42ad4c59008fff7c72b251e4f4ec106f81fd542603d708bb1ff4" => :big_sur
    sha256 "b4be5a6878b064979ad4ac52cdad2a4d98b344809bde0ead1a7e91370fdc2ed6" => :arm64_big_sur
    sha256 "4ecd0d9a33b6d44e4eaa58947893060e01dad9d7e1b67603db6af4cc4a870f43" => :catalina
    sha256 "2936f4b4f42ffe81269c28181e79ff04631748e2cb3a0d164aadcfd196b9d228" => :mojave
  end

  depends_on "python@3.9"

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
