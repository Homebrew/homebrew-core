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
  depends_on "python@3.11"

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/fd/6a/f07b0028baff9bca61ecfcd9ee021e7e33369da8094f00eff409f2ff32be/greenlet-2.0.1.tar.gz"
    sha256 "42e602564460da0e8ee67cb6d7236363ee5e131aa15943b6670e44e5c2ed0f67"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/22/44/0829b19ac243211d1d2bd759999aa92196c546518b0be91de9cacc98122a/msgpack-1.0.4.tar.gz"
    sha256 "f5d869c18f030202eb412f08b28d2afeea553d6613aee89e200d7aca7ef01f5f"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/3d/7d/d05864a69e452f003c0d77e728e155a89a2a26b09e64860ddd70ad64fb26/psutil-5.9.4.tar.gz"
    sha256 "3d7f9739eb435d4b1338944abe23f49584bde5395f27487d2ee25ad9a8774a62"
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
