class NeovimRemote < Formula
  include Language::Python::Virtualenv

  desc "Control nvim processes using `nvr` command-line tool"
  homepage "https://github.com/mhinz/neovim-remote"
  url "https://files.pythonhosted.org/packages/69/50/4fe9ef6fd794929ceae73e476ac8a4ddbf3b0913fa248d834c9bb72978b7/neovim-remote-2.5.1.tar.gz"
  sha256 "4b3cc35463544c5747c895c52a0343cfdbba15d307647d7f57f1cce0c6a27d02"
  license "MIT"
  head "https://github.com/mhinz/neovim-remote.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f980706b34fe571d0a79ecc93d044ed123cee711067febb1bc5648d6b3e32579"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8623a84cc3efb21f6c06bdf385f174326b18b41c02a2be1d0e584e0bb03ce75c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8728ddcde8d9f9735a95b32d70e206525a98c6d1dbbcb79d0cdff89db4eb1a33"
    sha256 cellar: :any_skip_relocation, sonoma:         "90bd4d9cdb03d800e8babb6dfe7b9ecc2dbba301159986d6062ac8cf74060928"
    sha256 cellar: :any_skip_relocation, ventura:        "63ff717460bac417a09bec0d9a96c96c8df067610668795e8ace4cb43beb5073"
    sha256 cellar: :any_skip_relocation, monterey:       "551ba8060da6e18a8fe81407c2cc039e4c8ee8d47df0453825454b3cea07bec2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cdf332a93e94684b793cc33222126d4abd8b4af6d6d97c0dd2e06c12ba35d7c"
  end

  depends_on "neovim"
  depends_on "python-psutil"
  depends_on "python@3.12"

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/d2/62/c657462190d198a45f37e613f910d27cfe8fed6faaeddec004d75dba6811/greenlet-3.0.2.tar.gz"
    sha256 "1c1129bc47266d83444c85a8e990ae22688cf05fb20d7951fd2866007c2ba9bc"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/c2/d5/5662032db1571110b5b51647aed4b56dfbd01bfae789fa566a2be1f385d1/msgpack-1.0.7.tar.gz"
    sha256 "572efc93db7a4d27e404501975ca6d2d9775705c2d922390d878fcf768d92c87"
  end

  resource "pynvim" do
    url "https://files.pythonhosted.org/packages/ce/17/259ab6acfb3fc85e209a649b0de1800c50f875bb946ac9df050827da8970/pynvim-0.5.0.tar.gz"
    sha256 "e80a11f6f5d194c6a47bea4135b90b55faca24da3544da7cf4a5f7ba8fb09215"
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
