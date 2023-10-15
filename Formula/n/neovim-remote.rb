class NeovimRemote < Formula
  include Language::Python::Virtualenv

  desc "Control nvim processes using `nvr` command-line tool"
  homepage "https://github.com/mhinz/neovim-remote"
  url "https://files.pythonhosted.org/packages/69/50/4fe9ef6fd794929ceae73e476ac8a4ddbf3b0913fa248d834c9bb72978b7/neovim-remote-2.5.1.tar.gz"
  sha256 "4b3cc35463544c5747c895c52a0343cfdbba15d307647d7f57f1cce0c6a27d02"
  license "MIT"
  head "https://github.com/mhinz/neovim-remote.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11cf9bbc583b6e0ab169a0f39e1383cc549162523bbe5594442f5d29259ea520"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45102b633d6c3ea52df5a54b2aaaf9a3c86d3d8ab0e1d409e7dbe8f90f625ad3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c10cd5d480c570373ba7fe4d629b7a40b3a41b2cac242ce62cd7b52fac2cac2"
    sha256 cellar: :any_skip_relocation, ventura:        "d2ed0b820e8e17e93cd3a3655ab3658f6ff8176c1dbe238b00f7a9d7ab8bdda7"
    sha256 cellar: :any_skip_relocation, monterey:       "a60c1065aafc55524a57eebdd75facd52432a37d3a3663ed053748b8042b78d2"
    sha256 cellar: :any_skip_relocation, big_sur:        "c26fd309db614a1b36d08c4bee8da33444ef525903574f5575fe6964639c6a4c"
    sha256 cellar: :any_skip_relocation, catalina:       "bad631e4f3a4393e233ae231ff191448672affe0aeea8addde4d086f4aa7192a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d06a5d88810e44a27c54469b23544650dc67d566117303a76887e0a3f5ac9f16"
  end

  depends_on "neovim"
  depends_on "python@3.12"

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/b6/02/47dbd5e1c9782e6d3f58187fa10789e308403f3fc3a490b3646b2bff6d9f/greenlet-3.0.0.tar.gz"
    sha256 "19834e3f91f485442adc1ee440171ec5d9a4840a1f7bd5ed97833544719ce10b"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/c2/d5/5662032db1571110b5b51647aed4b56dfbd01bfae789fa566a2be1f385d1/msgpack-1.0.7.tar.gz"
    sha256 "572efc93db7a4d27e404501975ca6d2d9775705c2d922390d878fcf768d92c87"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/2d/01/beb7331fc6c8d1c49dd051e3611379bfe379e915c808e1301506027fce9d/psutil-5.9.6.tar.gz"
    sha256 "e4b92ddcd7dd4cdd3f900180ea1e104932c7bce234fb88976e2a3b296441225a"
  end

  resource "pynvim" do
    url "https://files.pythonhosted.org/packages/7a/01/2d0898ba6cefbe2736283ee3155cba1c602de641ca5667ac55a0e4857276/pynvim-0.4.3.tar.gz"
    sha256 "3a795378bde5e8092fbeb3a1a99be9c613d2685542f1db0e5c6fd467eed56dff"
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
