class NeovimRemote < Formula
  include Language::Python::Virtualenv

  desc "Control nvim processes using `nvr` command-line tool"
  homepage "https://github.com/mhinz/neovim-remote"
  url "https://files.pythonhosted.org/packages/90/41/d91d81c2d27d1eb50c05f2fb5f52500b84e249e714748526d5074211d5fd/neovim-remote-2.4.2.tar.gz"
  sha256 "a5935c8b70dd85cd3470805f2aa15c809dca1e228e79c6bcdc1fea880923f150"
  license "MIT"
  head "https://github.com/mhinz/neovim-remote.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0568bf3cb14f9e28c2700a629657b3f2fff0f18b0d3ff4466a8aa93f3c73898e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e0d20a2667bc55a954a1e62e6f6e7e6fe32905b57d204cd7ae1f2b7f8ab69fe"
    sha256 cellar: :any_skip_relocation, monterey:       "62d48f9615d8199367d901a3ff7dab155c6dcac6a647e4095b1d7a0dd3d4c327"
    sha256 cellar: :any_skip_relocation, big_sur:        "2397e3153ca914d67937fb22329d761f6db9c391d5b2eb6dedaa20f3ba6b5b90"
    sha256 cellar: :any_skip_relocation, catalina:       "3d6ce83585c9dba3b3603c945b941ff6695fd71e41a01d2a75076b45fa9326d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ec3ab6e795babba12cc2bded96c466680c99526f970f6b101568e32214fa077"
  end

  depends_on "neovim"
  depends_on "python@3.10"

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/0c/10/754e21b5bea89d0e73f99d60c83754df7cc64db74f47d98ab187669ce341/greenlet-1.1.2.tar.gz"
    sha256 "e30f5ea4ae2346e62cedde8794a56858a67b878dd79f7df76a0767e356b1744a"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/61/3c/2206f39880d38ca7ad8ac1b28d2d5ca81632d163b2d68ef90e46409ca057/msgpack-1.0.3.tar.gz"
    sha256 "51fdc7fb93615286428ee7758cecc2f374d5ff363bdd884c7ea622a7a327a81e"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/47/b6/ea8a7728f096a597f0032564e8013b705aa992a0990becd773dcc4d7b4a7/psutil-5.9.0.tar.gz"
    sha256 "869842dbd66bb80c3217158e629d6fceaecc3a3166d3d1faee515b05dd26ca25"
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
