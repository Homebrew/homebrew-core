class Gitfs < Formula
  include Language::Python::Virtualenv

  desc "Version controlled file system"
  homepage "https://www.presslabs.com/gitfs"
  url "https://github.com/PressLabs/gitfs/archive/0.4.5.1.tar.gz"
  sha256 "6049fd81182d9172e861d922f3e2660f76366f85f47f4c2357f769d24642381c"
  head "https://github.com/PressLabs/gitfs.git"

  bottle do
    cellar :any
    sha256 "ca270f78333fea7499f5f0c705e8a9c6b04916442c141931018e96cd62b4484a" => :sierra
    sha256 "21774278959656c3b8166a1096bf955df7aa69f4486be25008032b9fa1f7b548" => :el_capitan
    sha256 "7d536833c2ba5177a4c3dc0d7604ed4b3c0961896b838f79e807ce3d7bec59a5" => :yosemite
  end

  depends_on "libgit2"
  depends_on :osxfuse
  depends_on :python if MacOS.version <= :snow_leopard

  resource "atomiclong" do
    url "https://files.pythonhosted.org/packages/86/8c/70aea8215c6ab990f2d91e7ec171787a41b7fbc83df32a067ba5d7f3324f/atomiclong-0.1.1.tar.gz"
    sha256 "cb1378c4cd676d6f243641c50e277504abf45f70f1ea76e446efcdbb69624bbe"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/83/3c/00b553fd05ae32f27b3637f705c413c4ce71290aa9b4c4764df694e906d9/cffi-1.7.0.tar.gz"
    sha256 "6ed5dd6afd8361f34819c68aaebf9e8fc12b5a5893f91f50c9e50c8886bb60df"
  end

  resource "fusepy" do
    url "https://files.pythonhosted.org/packages/source/f/fusepy/fusepy-2.0.2.tar.gz"
    sha256 "aa5929d5464caed81406481a330dc975d1a95b9a41d0a98f095c7e18fe501bfc"
  end

  resource "pygit2" do
    url "https://files.pythonhosted.org/packages/08/d5/6cc33ce2990b8502d9796902f686e622f647f3f59d5b7123e4d17ad34769/pygit2-0.25.0.tar.gz"
    sha256 "de0ed85fd840dfeb32bcaa94c643307551dc0d967c3714e49087e7edc0cdc571"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats; <<-EOS.undent
    gitfs clones repos in /var/lib/gitfs. You can either create it with
    sudo mkdir -m 1777 /var/lib/gitfs or use another folder with the
    repo_path argument.

    Also make sure OSXFUSE is properly installed by running brew info osxfuse.
    EOS
  end

  test do
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"

    (testpath/"test.py").write <<-EOS.undent
      import gitfs
      import pygit2
      pygit2.init_repository('testing/.git', True)
    EOS

    system "python", "test.py"
    assert File.exist?("testing/.git/config")
    cd "testing" do
      system "git", "remote", "add", "homebrew", "https://github.com/Homebrew/homebrew.git"
      assert_match "homebrew", shell_output("git remote")
    end
  end
end
