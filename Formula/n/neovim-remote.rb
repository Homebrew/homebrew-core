class NeovimRemote < Formula
  include Language::Python::Virtualenv

  desc "Control nvim processes using `nvr` command-line tool"
  homepage "https://github.com/mhinz/neovim-remote"
  url "https://files.pythonhosted.org/packages/69/50/4fe9ef6fd794929ceae73e476ac8a4ddbf3b0913fa248d834c9bb72978b7/neovim-remote-2.5.1.tar.gz"
  sha256 "4b3cc35463544c5747c895c52a0343cfdbba15d307647d7f57f1cce0c6a27d02"
  license "MIT"
  revision 1
  head "https://github.com/mhinz/neovim-remote.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b0ffdc95e7cebdea67c3b7c76eccb632421a62fe2973ea2c63673f23ce3b1eca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed26f80c996be6c16958ca2c57a3f3acfe5ef28a247707a6a0c041146ef2b417"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f949d8811fffc0098685241d5dc5a2b839eb233d9a2ea9b9cd1ad754b4379424"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa7a5c8443505049ffcd3cb3a85667e8c12ec810f1064fc96cc2b293ba7df79d"
    sha256 cellar: :any_skip_relocation, ventura:        "96ae9384c223792bf0a3d595aaa088871b8fdce54f4896c289b933d72545cba3"
    sha256 cellar: :any_skip_relocation, monterey:       "8722a4b9987c6662dd5bb5007797b9a56099e1e9f52534d999a5c2d96696766e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90497fa2baead9fa8b8e8c74a7dae31362130095fe7490b02597661a0884c03f"
  end

  depends_on "neovim"
  depends_on "python@3.12"

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/17/14/3bddb1298b9a6786539ac609ba4b7c9c0842e12aa73aaa4d8d73ec8f8185/greenlet-3.0.3.tar.gz"
    sha256 "43374442353259554ce33599da8b692d5aa96f8976d567d4badf263371fbe491"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/c2/d5/5662032db1571110b5b51647aed4b56dfbd01bfae789fa566a2be1f385d1/msgpack-1.0.7.tar.gz"
    sha256 "572efc93db7a4d27e404501975ca6d2d9775705c2d922390d878fcf768d92c87"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/90/c7/6dc0a455d111f68ee43f27793971cf03fe29b6ef972042549db29eec39a2/psutil-5.9.8.tar.gz"
    sha256 "6be126e3225486dff286a8fb9a06246a5253f4c7c53b475ea5f5ac934e64194c"
  end

  resource "pynvim" do
    url "https://files.pythonhosted.org/packages/ce/17/259ab6acfb3fc85e209a649b0de1800c50f875bb946ac9df050827da8970/pynvim-0.5.0.tar.gz"
    sha256 "e80a11f6f5d194c6a47bea4135b90b55faca24da3544da7cf4a5f7ba8fb09215"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c9/3d/74c56f1c9efd7353807f8f5fa22adccdba99dc72f34311c30a69627a0fad/setuptools-69.1.0.tar.gz"
    sha256 "850894c4195f09c4ed30dba56213bf7c3f21d86ed6bdaafb5df5972593bfc401"
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
