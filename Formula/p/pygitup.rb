class Pygitup < Formula
  include Language::Python::Virtualenv

  desc "Nicer 'git pull'"
  homepage "https://github.com/msiemens/PyGitUp"
  url "https://files.pythonhosted.org/packages/55/13/2dd3d4c9a021eb5fa6d8afbb29eb9e6eb57faa56cf10effe879c9626eed1/git_up-2.2.0.tar.gz"
  sha256 "1935f62162d0e3cc967cf9e6b446bd1c9e6e9902edb6a81396065095a5a0784e"
  license "MIT"
  revision 5

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6746d3c1acb5294ca7dcd7e7a085c110678fa5ffb9f8706a46708e62b930c06"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13d1719d8586becd76bddf9b43f915ef2ad0873f1f2ffbfd6e8107c8cd4286bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9b7d88bbb1adf87e846f096cdcfa465d61a6b2a13052e9554b45b7cc6be810c"
    sha256 cellar: :any_skip_relocation, sonoma:         "41b5d5e0f2280aee545a89c04e8f9eb653a910cfb035c9dcc3a9848510cc0a4c"
    sha256 cellar: :any_skip_relocation, ventura:        "0204d02a08f668f4cf792bd6dd1c3c735d854aa68ee34ffa4fdb541eeb698505"
    sha256 cellar: :any_skip_relocation, monterey:       "438edf0db2170381b6b3c698ab2267d706a532e9aba6c3231d33b0a00dc5397f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13dad9f3c5e8548ab83d77c11f871e693551c5e580f9033c4c2db855f5eed0da"
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
    url "https://files.pythonhosted.org/packages/c6/33/5e633d3a8b3dbec3696415960ed30f6718ed04ef423ce0fbc6512a92fa9a/GitPython-3.1.37.tar.gz"
    sha256 "f9b9ddc0761c125d5780eab2d64be4873fc6817c2899cbcb34b02344bdc7bc54"
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
