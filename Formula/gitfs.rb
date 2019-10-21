class Gitfs < Formula
  include Language::Python::Virtualenv

  desc "Version controlled file system"
  homepage "https://www.presslabs.com/gitfs"
  url "https://github.com/PressLabs/gitfs/archive/0.4.5.1.tar.gz"
  sha256 "6049fd81182d9172e861d922f3e2660f76366f85f47f4c2357f769d24642381c"
  revision 5
  head "https://github.com/PressLabs/gitfs.git"

  bottle do
    cellar :any
    sha256 "672ed08730f673fd497b265c3673ce6c36e00fc7c4b4e2f3f5396af7aa2ff049" => :catalina
    sha256 "20e5dfcf7b3c802cf39420d7c4b8093381fbe8112d498d936e2e0ce10b85f6da" => :mojave
    sha256 "10e417686bf747da730f9c08659b4ba4801236a3ed0821e125580e99fbfe27a2" => :high_sierra
  end

  depends_on "libgit2"
  depends_on :osxfuse
  depends_on "python"

  resource "atomiclong" do
    url "https://files.pythonhosted.org/packages/86/8c/70aea8215c6ab990f2d91e7ec171787a41b7fbc83df32a067ba5d7f3324f/atomiclong-0.1.1.tar.gz"
    sha256 "cb1378c4cd676d6f243641c50e277504abf45f70f1ea76e446efcdbb69624bbe"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/93/1a/ab8c62b5838722f29f3daffcc8d4bd61844aa9b5f437341cc890ceee483b/cffi-1.12.3.tar.gz"
    sha256 "041c81822e9f84b1d9c401182e174996f0bae9991f33725d059b771744290774"
  end

  resource "fusepy" do
    url "https://files.pythonhosted.org/packages/70/aa/959d781b7ac979af1a9fbea0faffe06677c390907b56b8ce024eb9320451/fusepy-2.0.4.tar.gz"
    sha256 "10f5c7f5414241bffecdc333c4d3a725f1d6605cae6b4eaf86a838ff49cdaf6c"
  end

  resource "pygit2" do
    url "https://files.pythonhosted.org/packages/ec/56/9f591bee962dcdc3c4268c4bf0a836d5188b1604e58e3618df12a963573b/pygit2-0.28.1.tar.gz"
    sha256 "2ccdb865ef530c799a6430d0e52952925ffc0d7c856e7608f4cf42f4b821412b"
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
