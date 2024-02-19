class Pygitup < Formula
  include Language::Python::Virtualenv

  desc "Nicer 'git pull'"
  homepage "https://github.com/msiemens/PyGitUp"
  url "https://files.pythonhosted.org/packages/55/13/2dd3d4c9a021eb5fa6d8afbb29eb9e6eb57faa56cf10effe879c9626eed1/git_up-2.2.0.tar.gz"
  sha256 "1935f62162d0e3cc967cf9e6b446bd1c9e6e9902edb6a81396065095a5a0784e"
  license "MIT"
  revision 6

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a384990db1b3e3f2625f9226d38ca337adcf868077e85503350f799a27e9984"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed785f9a38575c102603254e759afa5ce86202c9f42204afc5c5730cf7cc1df0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2c3ea016f0a8ce1981d57d3a49cce5b2e96bc4a3e20e36bc5a7963791a5135f"
    sha256 cellar: :any_skip_relocation, sonoma:         "015a278ebff4ca3add1bb8ac5d2acfd0ba205e901e2e9f3052e9b26b2deb4d7e"
    sha256 cellar: :any_skip_relocation, ventura:        "b05e762720ffb2d1629ca7fff66b15f3ad2e7f939548a2aa7c5f0b9d7dcb4e84"
    sha256 cellar: :any_skip_relocation, monterey:       "f2c8f7009e59e28941c4823fb94b217481a53bde505d9e172f4b6f3e3814e447"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe772ee98b9633d8d4bea9033faf56a4e47d67ea55fe149070068d03a9ea60c1"
  end

  depends_on "python-typing-extensions"
  depends_on "python@3.12"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/19/0d/bbb5b5ee188dec84647a4664f3e11b06ade2bde568dbd489d9d64adef8ed/gitdb-4.0.11.tar.gz"
    sha256 "bf5421126136d6d0af55bc1e7c1af1c397a34f5b7bd79e776cd3e89785c2b04b"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/e5/c2/6e3a26945a7ff7cf2854b8825026cf3f22ac8e18285bc11b6b1ceeb8dc3f/GitPython-3.1.41.tar.gz"
    sha256 "ed66e624884f76df22c8e16066d567aaa5a37d5b5fa19db2c6df6f7156db9048"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/88/04/b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baa/smmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/10/56/d7d66a84f96d804155f6ff2873d065368b25a07222a6fd51c4f24ef6d764/termcolor-2.4.0.tar.gz"
    sha256 "aab9e56047c8ac41ed798fa36d892a37aca6b3e9159f3e0c24bc64a9b3ac7b7a"
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
