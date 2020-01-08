class GitRemoteHg < Formula
  include Language::Python::Virtualenv

  desc "Transparent bidirectional bridge between Git and Mercurial"
  homepage "https://github.com/felipec/git-remote-hg"
  url "https://github.com/felipec/git-remote-hg/archive/v0.4.tar.gz"
  sha256 "916072d134cde65b7ffa7d1da1acaabb0f29b65c017d0560e907e7a94063d1b1"
  revision 1
  head "https://github.com/felipec/git-remote-hg.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2c6c0aa20d34840e7e1618f77380f709f3002111b6ec459999320a4a13389a86" => :catalina
    sha256 "463beb7f146cafc2330852d5fbc68b87783f5b7b972771219f71e6b6b7a54d09" => :mojave
    sha256 "5e38497ae428fbb1037e914840c989391a5765bdb6f87ad88960084b3f625db3" => :high_sierra
  end

  depends_on "mercurial"
  uses_from_macos "python@2" # does not support Python 3

  conflicts_with "git-cinnabar", :because => "both install `git-remote-hg` binaries"

  resource "hg" do
    url "https://mercurial-scm.org/release/mercurial-4.1.3.tar.gz"
    sha256 "103d2ae187d5c94110c0e86ccc3b46f55fcd8e21c78d1c209bac7b59a73e86d8"
  end

  def install
    venv = virtualenv_create(libexec)
    venv.pip_install resource("hg")
    inreplace "git-remote-hg", /#!.*/, "#!#{libexec}/bin/python"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "git", "clone", "hg::https://www.mercurial-scm.org/repo/hello"
  end
end
