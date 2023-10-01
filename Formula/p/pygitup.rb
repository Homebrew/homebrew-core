class Pygitup < Formula
  include Language::Python::Virtualenv

  desc "Nicer 'git pull'"
  homepage "https://github.com/msiemens/PyGitUp"
  url "https://files.pythonhosted.org/packages/55/13/2dd3d4c9a021eb5fa6d8afbb29eb9e6eb57faa56cf10effe879c9626eed1/git_up-2.2.0.tar.gz"
  sha256 "1935f62162d0e3cc967cf9e6b446bd1c9e6e9902edb6a81396065095a5a0784e"
  license "MIT"
  revision 4

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "410b4b0c43dfba5d96493eed825c3f5787fcc9dfddaa8339a089acd639917c2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3caef7b708c7a4619c6c54ba91519f5a5286c72b42e538ce26b3e4ff5607f958"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "550ca56e0ca9bc748a14cf3191874f9fbcb5723c62f2cdfc5e4e551f455600bd"
    sha256 cellar: :any_skip_relocation, ventura:        "63c552de33d45c558d03215885bd18b4ac6cd3a547d68bd7789b39cdfec4d992"
    sha256 cellar: :any_skip_relocation, monterey:       "f38ad79505b0ccd2fce9e1284eac12b1b1e38da4d8a878367d7ece456c3d7635"
    sha256 cellar: :any_skip_relocation, big_sur:        "edeaae1dc183881ad5df88aebc6cc7752802a59218648945f2b95db1009bd409"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5ff59a8b63cd8abf2fc1da78b5c08b75c60a48d36254cc2529581536ca78a18"
  end

  depends_on "python-typing-extensions"
  depends_on "python@3.11"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/4b/47/dc98f3d5d48aa815770e31490893b92c5f1cd6c6cf28dd3a8ae0efffac14/gitdb-4.0.10.tar.gz"
    sha256 "6eb990b69df4e15bad899ea868dc46572c3f75339735663b81de79b06f17eb9a"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/95/4e/8b8aac116a00f0681117ed3c3f3fc7c93fcf85eaad53e5e6dea86f7b8d82/GitPython-3.1.35.tar.gz"
    sha256 "9cbefbd1789a5fe9bcf621bb34d3f441f3a90c8461d377f84eda73e721d9b06b"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
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
