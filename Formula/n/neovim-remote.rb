class NeovimRemote < Formula
  include Language::Python::Virtualenv

  desc "Control nvim processes using `nvr` command-line tool"
  homepage "https://github.com/mhinz/neovim-remote"
  url "https://files.pythonhosted.org/packages/69/50/4fe9ef6fd794929ceae73e476ac8a4ddbf3b0913fa248d834c9bb72978b7/neovim-remote-2.5.1.tar.gz"
  sha256 "4b3cc35463544c5747c895c52a0343cfdbba15d307647d7f57f1cce0c6a27d02"
  license "MIT"
  head "https://github.com/mhinz/neovim-remote.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5b2421bba7714a9ac3ba6af4dcf7b6d5e1b23d9e2fc6d536ae29979d3d931e27"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd06fdba9c046945b562a51d64b50a4cc2569876b6006b360a70947aca3b1f76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4ae9d3e06f8960f92a0ea44b07581ae1cbe39a2e2ceb897d072c1b3d220bf19"
    sha256 cellar: :any_skip_relocation, sonoma:         "e3cce27f8b638674e3de6af3585ab0302a513fa781975862653eceb235318af9"
    sha256 cellar: :any_skip_relocation, ventura:        "7e1fb0f87fab109c0f39565ab978cf7896e1bcdb30eb20493ddf1bc7ecc90ddb"
    sha256 cellar: :any_skip_relocation, monterey:       "700902934bcb3846c11387bda29b36123773e627704236a4a7541abe6e7cd172"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5006841176b575774b70f44609e28dc5a5a5ce14207b3fedf0fd796e6a4cbce8"
  end

  depends_on "neovim"
  depends_on "python-psutil"
  depends_on "python@3.11"

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/54/df/718c9b3e90edba70fa919bb3aaa5c3c8dabf3a8252ad1e93d33c348e5ca4/greenlet-3.0.1.tar.gz"
    sha256 "816bd9488a94cba78d93e1abb58000e8266fa9cc2aa9ccdd6eb0696acb24005b"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/c2/d5/5662032db1571110b5b51647aed4b56dfbd01bfae789fa566a2be1f385d1/msgpack-1.0.7.tar.gz"
    sha256 "572efc93db7a4d27e404501975ca6d2d9775705c2d922390d878fcf768d92c87"
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
