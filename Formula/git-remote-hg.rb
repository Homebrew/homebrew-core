class GitRemoteHg < Formula
  include Language::Python::Virtualenv

  desc "Transparent bidirectional bridge between Git and Mercurial"
  homepage "https://github.com/felipec/git-remote-hg"
  url "https://github.com/felipec/git-remote-hg/archive/v0.3.tar.gz"
  sha256 "2dc889b641d72f5a73c4c7d5df3b8ea788e75a7ce80f5884a7a8d2e099287dce"
  head "https://github.com/felipec/git-remote-hg.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3c3a3ba464469298a0e1fb01bb85954f91e1baca5c6863e8bbd2455bac8e741e" => :high_sierra
    sha256 "f0b8d090aaf5e8aa4b63418efcc8a0e6fc1fe7cafc39bee6a8bc85abd8c106db" => :sierra
    sha256 "6af3e5642dbe91d832b035baf74d199cbda4af7bdb39b0a0d09d336098fa4693" => :el_capitan
    sha256 "45529e66698b9505e61c718d43f46c99dc31ef2b37802939e17d391ede5ae912" => :yosemite
  end

  depends_on "mercurial"
  depends_on "python" if MacOS.version <= :snow_leopard

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
