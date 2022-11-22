class Pygitup < Formula
  include Language::Python::Virtualenv

  desc "Nicer 'git pull'"
  homepage "https://github.com/msiemens/PyGitUp"
  url "https://files.pythonhosted.org/packages/55/13/2dd3d4c9a021eb5fa6d8afbb29eb9e6eb57faa56cf10effe879c9626eed1/git_up-2.2.0.tar.gz"
  sha256 "1935f62162d0e3cc967cf9e6b446bd1c9e6e9902edb6a81396065095a5a0784e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e334b7e9e18589dfc6b2d615a8746a69336d0fb54e9e675c15ead5aa4d0f19e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fef07b7a13d65448ae0570887e2d8393457b9eab037246ec791559b28f64c1d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f347a89960458f826ee638da7c95acacee1c7532fc7b392a19186d0b56718fc8"
    sha256 cellar: :any_skip_relocation, ventura:        "f88c27588eb7780db33684a8843a75a914dcd237f9415017a95c951ff45f876d"
    sha256 cellar: :any_skip_relocation, monterey:       "7bdd0ba57788f533752fd172ead77cc8875d0f73f6aa411cf8081f2fe4dac734"
    sha256 cellar: :any_skip_relocation, big_sur:        "38467c6e09fbf2c552a812770fe9f47e6eab7ac238c34b3351f41e8685bce6ad"
    sha256 cellar: :any_skip_relocation, catalina:       "a558b5e0e15a0f023e5391670c5fff6227d8a319cbcd1f0e8aad09eb27578e06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d75e1193d548457336d13ed25d9b5fadc01b1d2923edcded6e071990759f50c6"
  end

  depends_on "python-typing-extensions"
  depends_on "python@3.11"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/fc/44/64e02ef96f20b347385f0e9c03098659cb5a1285d36c3d17c56e534d80cf/gitdb-4.0.9.tar.gz"
    sha256 "bac2fd45c0a1c9cf619e63a90d62bdc63892ef92387424b855792a6cabe789aa"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/22/ab/3dd8b8a24399cee9c903d5f7600d20e8703d48904020f46f7fa5ac5474e9/GitPython-3.1.29.tar.gz"
    sha256 "cc36bfc4a3f913e66805a28e84703e419d9c264c1077e537b54f0e1af85dbefd"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/19/da/ff1f0906818a5bd2e69e773d88801ca3c9e92d0d7caa99db1665658819ea/termcolor-2.1.1.tar.gz"
    sha256 "67cee2009adc6449c650f6bcf3bdeed00c8ba53a8cda5362733c53e0a39fb70b"
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
