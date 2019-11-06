class GitRevise < Formula
  include Language::Python::Virtualenv

  desc "Rebase alternative for easy & efficient in-memory rebases and fixups"
  homepage "https://github.com/mystor/git-revise"
  url "https://github.com/mystor/git-revise/archive/0.5.0.tar.gz"
  sha256 "f2bd6ad51b2acdd6fb6acf51807ce4b951d92cd039fc9e5a7dbb1e182fdf38b4"
  head "https://github.com/mystor/git-revise.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4ec22a44768012077828051f16076f7f058ab6140a7b4af8fbae9cd1d5d640be" => :catalina
    sha256 "46da814698d72cbd9a39feb563c7a3875488d1ed164ac0bdfdd23afdd60f3897" => :mojave
    sha256 "cdbc5d89bf0adc41adfe18ae14de0d51dfc537dd017ab0ca44fafdda8791ce23" => :high_sierra
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
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
