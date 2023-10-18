class Pygitup < Formula
  include Language::Python::Virtualenv

  desc "Nicer 'git pull'"
  homepage "https://github.com/msiemens/PyGitUp"
  url "https://files.pythonhosted.org/packages/55/13/2dd3d4c9a021eb5fa6d8afbb29eb9e6eb57faa56cf10effe879c9626eed1/git_up-2.2.0.tar.gz"
  sha256 "1935f62162d0e3cc967cf9e6b446bd1c9e6e9902edb6a81396065095a5a0784e"
  license "MIT"
  revision 5

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d0ef46493a9e8a09ce4a6e54daf64b1440642d8384ea3d7e69518fdcb8470497"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7163381e9d187685b383def07e489006e7d20e3b838d8a72bdb4358406628c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "519051e93c3268b5e0f70566a813e0bcc8accf7d039f52d8bf42acb50a043f49"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b3156ad3d3e93d2c61761af92d5ce9e88c3f400829a241b12a4deeb269c67bc"
    sha256 cellar: :any_skip_relocation, ventura:        "ed0f379a6ecb91d439626b2945b0979c6ac460929e71a8d1d9dc06f472c3f6a6"
    sha256 cellar: :any_skip_relocation, monterey:       "771ae7638d46dfe9216405c6bd34f7550071312e63ada19df115141383acf35d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e012d8df09e37aa40ce2567fcfc4ac9b1f8f643325eb959686ffbe9cc460f8a"
  end

  depends_on "python-typing-extensions"
  depends_on "python@3.12"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/4b/47/dc98f3d5d48aa815770e31490893b92c5f1cd6c6cf28dd3a8ae0efffac14/gitdb-4.0.10.tar.gz"
    sha256 "6eb990b69df4e15bad899ea868dc46572c3f75339735663b81de79b06f17eb9a"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/b3/45/cee7af549b6fa33f04531e402693a772b776cd9f845a2cbeca99cfac3331/GitPython-3.1.38.tar.gz"
    sha256 "4d683e8957c8998b58ddb937e3e6cd167215a180e1ffd4da769ab81c620a89fe"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/88/04/b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baa/smmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/b8/85/147a0529b4e80b6b9d021ca8db3a820fcac53ec7374b87073d004aaf444c/termcolor-2.3.0.tar.gz"
    sha256 "b5b08f68937f138fe92f6c089b99f1e2da0ae56c52b78bf7075fd95420fd9a5a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system "git", "clone", "https://github.com/Homebrew/install.git"
    cd "install" do
      assert_match "Fetching origin", shell_output("#{bin}/git-up")
    end
  end
end
