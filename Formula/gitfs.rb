class Gitfs < Formula
  include Language::Python::Virtualenv

  desc "Version controlled file system"
  homepage "https://www.presslabs.com/gitfs"
  url "https://github.com/PressLabs/gitfs/archive/0.4.5.1.tar.gz"
  sha256 "6049fd81182d9172e861d922f3e2660f76366f85f47f4c2357f769d24642381c"
  revision 3
  head "https://github.com/PressLabs/gitfs.git"

  bottle do
    cellar :any
    sha256 "f687f98ff761c63ce29e6e95b1b59de2a7b875eed52972ebf365c97647c64b17" => :mojave
    sha256 "3fd2dd617e55b282e12950ed3f02f22f92ec7cbda6a99d14948e0de2d1391f18" => :high_sierra
    sha256 "d2ebbc811955fc31e22f4f8e48441c1d768200a6a3a38dead2b9c688f1b406b4" => :sierra
  end

  depends_on "libgit2"
  depends_on :osxfuse
  depends_on "python"

  resource "atomiclong" do
    url "https://files.pythonhosted.org/packages/86/8c/70aea8215c6ab990f2d91e7ec171787a41b7fbc83df32a067ba5d7f3324f/atomiclong-0.1.1.tar.gz"
    sha256 "cb1378c4cd676d6f243641c50e277504abf45f70f1ea76e446efcdbb69624bbe"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/5b/b9/790f8eafcdab455bcd3bd908161f802c9ce5adbf702a83aa7712fcc345b7/cffi-1.10.0.tar.gz"
    sha256 "b3b02911eb1f6ada203b0763ba924234629b51586f72a21faacc638269f4ced5"
  end

  resource "fusepy" do
    url "https://files.pythonhosted.org/packages/70/aa/959d781b7ac979af1a9fbea0faffe06677c390907b56b8ce024eb9320451/fusepy-2.0.4.tar.gz"
    sha256 "10f5c7f5414241bffecdc333c4d3a725f1d6605cae6b4eaf86a838ff49cdaf6c"
  end

  resource "pygit2" do
    url "https://files.pythonhosted.org/packages/3b/0d/c11844421c7c3b9cb84c5503185bbb5ba780144fd64f5adde572bcdcdd8a/pygit2-0.27.0.tar.gz"
    sha256 "6febce4aea72f12ed5a1e7529b91119f21d93cb2ccb3f834eea26af76cc9a4cb"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats; <<~EOS
    gitfs clones repos in /var/lib/gitfs. You can either create it with
    sudo mkdir -m 1777 /var/lib/gitfs or use another folder with the
    repo_path argument.

    Also make sure OSXFUSE is properly installed by running brew info osxfuse.
  EOS
  end

  test do
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"

    (testpath/"test.py").write <<~EOS
      import gitfs
      import pygit2
      pygit2.init_repository('testing/.git', True)
    EOS

    system "python3", "test.py"
    assert_predicate testpath/"testing/.git/config", :exist?
    cd "testing" do
      system "git", "remote", "add", "homebrew", "https://github.com/Homebrew/homebrew.git"
      assert_match "homebrew", shell_output("git remote")
    end
  end
end
