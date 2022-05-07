class NeovimRemote < Formula
  include Language::Python::Virtualenv

  desc "Control nvim processes using `nvr` command-line tool"
  homepage "https://github.com/mhinz/neovim-remote"
  url "https://files.pythonhosted.org/packages/df/cb/ca9bbe164abcf5f47b61bcda3ca00ea9a5004231b60e806752f790fafdd0/neovim-remote-2.5.0.tar.gz"
  sha256 "1a35d133aa94d5980fcca68d6717783d6fcffee33bcab23b456397f0a099e88d"
  license "MIT"
  head "https://github.com/mhinz/neovim-remote.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9209666b504ea4f1fa0716f06c3668232593aa5f7e5959e1e2ed3d386678d843"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1182ca5599e320f40c40a36b0b7a87cf6e6ed8e4d8c98d0339a3653af268260"
    sha256 cellar: :any_skip_relocation, monterey:       "f84be79b9dc8af0fe1258d29d8c52ebbe6ef71ed6536840d6f2ae79b787e8726"
    sha256 cellar: :any_skip_relocation, big_sur:        "d613bdd272faf4d4e61897214ba5667048d0ebfec35be99ba99206f1c361d3f3"
    sha256 cellar: :any_skip_relocation, catalina:       "3bd1656e0828ae6b417e2ad281fa1516aa7e0843e2df6f9bff224610d43cfad7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "320eaa8a9485d1278793163df07bc1ecc44c045decedbd989e72ef15bd85474f"
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
