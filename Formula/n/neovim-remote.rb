class NeovimRemote < Formula
  include Language::Python::Virtualenv

  desc "Control nvim processes using `nvr` command-line tool"
  homepage "https://github.com/mhinz/neovim-remote"
  url "https://files.pythonhosted.org/packages/69/50/4fe9ef6fd794929ceae73e476ac8a4ddbf3b0913fa248d834c9bb72978b7/neovim-remote-2.5.1.tar.gz"
  sha256 "4b3cc35463544c5747c895c52a0343cfdbba15d307647d7f57f1cce0c6a27d02"
  license "MIT"
  revision 2
  head "https://github.com/mhinz/neovim-remote.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "969080e39441d8db18d446ebae92c9a95d1d4738d64ac3528d7be2787fcef349"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a92d145e3bfd46ebca31454bef1d0089cc2eb3f34991e73ccdfe7e83eb38165"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c90e4d80be180455c9922bcca4c7d9da06c52fa5a229c84c287f1bd3e93b0d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "005a3b436ae67a59fb9c41e20117e9fb8236ab8c255db39e511a51c31d918958"
    sha256 cellar: :any_skip_relocation, ventura:       "4867e1eb46ec92e136a1500a70b5675bd26a37b374cf89a47adba12c64045bcb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6657c430639a92f1d6d4a73f0a85d58bfb080e2cdfa437a92f17ff2cee10a7bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b914c93bc339131a9eafe74dd7b8ec2123a954934b29433aff5d6694644339e"
  end

  depends_on "neovim"
  depends_on "python@3.13"

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/2f/ff/df5fede753cc10f6a5be0931204ea30c35fa2f2ea7a35b25bdaf4fe40e46/greenlet-3.1.1.tar.gz"
    sha256 "4ce3ac6cdb6adf7946475d7ef31777c26d94bccc377e070a7986bd2d5c515467"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/cb/d0/7555686ae7ff5731205df1012ede15dd9d927f6227ea151e901c7406af4f/msgpack-1.1.0.tar.gz"
    sha256 "dd432ccc2c72b914e4cb77afce64aab761c1137cc698be3984eee260bcb2896e"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/18/c7/8c6872f7372eb6a6b2e4708b88419fb46b857f7a2e1892966b851cc79fc9/psutil-6.0.0.tar.gz"
    sha256 "8faae4f310b6d969fa26ca0545338b21f73c6b15db7c4a8d934a5482faa818f2"
  end

  resource "pynvim" do
    url "https://files.pythonhosted.org/packages/ce/17/259ab6acfb3fc85e209a649b0de1800c50f875bb946ac9df050827da8970/pynvim-0.5.0.tar.gz"
    sha256 "e80a11f6f5d194c6a47bea4135b90b55faca24da3544da7cf4a5f7ba8fb09215"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/27/b8/f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74b/setuptools-75.1.0.tar.gz"
    sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    socket = testpath/"nvimsocket"
    file = testpath/"test.txt"
    ENV["NVIM_LISTEN_ADDRESS"] = socket

    nvim = spawn(
      { "NVIM_LISTEN_ADDRESS" => socket },
      Formula["neovim"].opt_bin/"nvim", "--headless", "-i", "NONE", "-u", "NONE", file,
      [:out, :err] => "/dev/null"
    )
    sleep 5

    str = "Hello from neovim-remote!"
    system bin/"nvr", "--remote-send", "i#{str}<esc>:write<cr>"
    assert_equal str, file.read.chomp
    assert_equal Process.kill(0, nvim), 1

    system bin/"nvr", "--remote-send", ":quit<cr>"

    # Test will be terminated by the timeout
    # if `:quit` was not sent correctly
    Process.wait nvim
  end
end
