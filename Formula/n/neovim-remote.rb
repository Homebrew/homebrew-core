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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "44076220c890db67f1f6c73155bf09d0a1a16a7e311c2d5902850d807d13a99f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef7c8c6232879550244398bd714eecf0e095e5d1596b078c130896020308da1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36e97627bfe776404bf8c394ba69b88b264b188071162c8657ac9eab78610d64"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe2871a4eb7494b783dabe1bfcd8fc952d2281b2e8e2c20f87dd16e5e493ea53"
    sha256 cellar: :any_skip_relocation, ventura:        "478ce0c08e603679fdc09f0014292640aa3a89472000deb101052f7dcdd33a9b"
    sha256 cellar: :any_skip_relocation, monterey:       "deb2a5c039832523364fc3d9234e654e7a1bd7e11b124e1dafdb1680fdf5dd91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bac87a1858be13f772ca2036a6b900dfe108d3aeedcae603f0975358b74cee5"
  end

  depends_on "neovim"
  depends_on "python@3.12"

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/17/14/3bddb1298b9a6786539ac609ba4b7c9c0842e12aa73aaa4d8d73ec8f8185/greenlet-3.0.3.tar.gz"
    sha256 "43374442353259554ce33599da8b692d5aa96f8976d567d4badf263371fbe491"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/08/4c/17adf86a8fbb02c144c7569dc4919483c01a2ac270307e2d59e1ce394087/msgpack-1.0.8.tar.gz"
    sha256 "95c02b0e27e706e48d0e5426d1710ca78e0f0628d6e89d5b5a5b91a5f12274f3"
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
    url "https://files.pythonhosted.org/packages/65/d8/10a70e86f6c28ae59f101a9de6d77bf70f147180fbf40c3af0f64080adc3/setuptools-70.3.0.tar.gz"
    sha256 "f171bab1dfbc86b132997f26a119f6056a57950d058587841a0082e8830f9dc5"
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
