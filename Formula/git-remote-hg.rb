class GitRemoteHg < Formula
  include Language::Python::Virtualenv

  desc "Transparent bidirectional bridge between Git and Mercurial"
  homepage "https://github.com/felipec/git-remote-hg"
  url "https://github.com/felipec/git-remote-hg/archive/v0.4.tar.gz"
  sha256 "916072d134cde65b7ffa7d1da1acaabb0f29b65c017d0560e907e7a94063d1b1"
  head "https://github.com/felipec/git-remote-hg.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd29f07fbc50952fa8f97420e26f07f9fe4d26222620f1c8b8cf50a0236b0643" => :catalina
    sha256 "d31145dbac316f9c7540d75dd6aafbcc4a2e075ec9c021efd41b4c087c186c1d" => :mojave
    sha256 "cae74b1c19b7f028810a213128de4ae3b33c909930ff25e76209bfbd65b9bbb7" => :high_sierra
    sha256 "d21a60283d278cd8e4fb3d5c76622edf49b64a19b300dbb5f71c91f967eed610" => :sierra
  end

  depends_on "mercurial"
  depends_on "python@2" # does not support Python 3

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
