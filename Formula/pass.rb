class Pass < Formula
  desc "Password manager"
  homepage "https://www.passwordstore.org/"
  url "https://git.zx2c4.com/password-store/snapshot/password-store-1.6.5.tar.xz"
  sha256 "337a39767e6a8e69b2bcc549f27ff3915efacea57e5334c6068fcb72331d7315"
  revision 1

  head "https://git.zx2c4.com/password-store", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "b9d356a1b3a8aff31e29c8db18aaa80d6998ab29ef5d0d8c098404eef5d2b5c2" => :sierra
    sha256 "b836275ace8b8e585a1ef824795f54b7a8b124228237982fbb6ee9ff12411616" => :el_capitan
    sha256 "6ef1fee60f542dd951897b5085ac9c1f76a772a27d9b90a4097966e5b6bf7df2" => :yosemite
    sha256 "c709c4f11aff94b6cf9ca73007013c23b4dfb1f7f45fdb0e4b4e5ea96374175e" => :mavericks
  end

  depends_on "pwgen"
  depends_on "tree"
  depends_on "gnu-getopt"
  depends_on :gpg => :run

  def install
    system "make", "PREFIX=#{prefix}", "install"
    pkgshare.install "contrib"
    zsh_completion.install "src/completion/pass.zsh-completion" => "_pass"
    bash_completion.install "src/completion/pass.bash-completion" => "password-store"
    fish_completion.install "src/completion/pass.fish-completion" => "pass.fish"
  end

  test do
    Gpg.create_test_key(testpath)
    system bin/"pass", "init", "Testing"
    system bin/"pass", "generate", "Email/testing@foo.bar", "15"
    assert File.exist?(".password-store/Email/testing@foo.bar.gpg")
  end
end
