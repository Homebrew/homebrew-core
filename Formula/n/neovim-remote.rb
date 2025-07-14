class NeovimRemote < Formula
  include Language::Python::Virtualenv

  desc "Control nvim processes using `nvr` command-line tool"
  homepage "https://github.com/mhinz/neovim-remote"
  url "https://files.pythonhosted.org/packages/69/50/4fe9ef6fd794929ceae73e476ac8a4ddbf3b0913fa248d834c9bb72978b7/neovim-remote-2.5.1.tar.gz"
  sha256 "4b3cc35463544c5747c895c52a0343cfdbba15d307647d7f57f1cce0c6a27d02"
  license "MIT"
  revision 3
  head "https://github.com/mhinz/neovim-remote.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9edaf9f4d2feb2e6e4f18dc167944ff8823c9c4068c6e07017d8921ca160b28a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9b76e1afa8be0eec8c8fd7197460b4477faaf325cd2fc18c0339ee725b06a8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "949b8dd9dc1b6fcaa86472561cec958b13a0c204be09e5634341601db3fe5f98"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1d9cff133d630041fe8d16efd19643523f4dfbb248840c9b4f932ca01902d07"
    sha256 cellar: :any_skip_relocation, ventura:       "95452863449dda54f90ae2dd8a3c01732634b8a974ced293149747b7551813d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a8c3e1a56addbd31b292339933393e6e354b7e02f7cd9c3a4c05a3f58e7a014"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a7e179568b81994be74447f225712ad2efeef31045af99657a6671f6a98a963"
  end

  depends_on "neovim"
  depends_on "python@3.13"

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/34/c1/a82edae11d46c0d83481aacaa1e578fea21d94a1ef400afd734d47ad95ad/greenlet-3.2.2.tar.gz"
    sha256 "ad053d34421a2debba45aa3cc39acf454acbcd025b3fc1a9f8a0dee237abd485"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/cb/d0/7555686ae7ff5731205df1012ede15dd9d927f6227ea151e901c7406af4f/msgpack-1.1.0.tar.gz"
    sha256 "dd432ccc2c72b914e4cb77afce64aab761c1137cc698be3984eee260bcb2896e"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/2a/80/336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3de/psutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  resource "pynvim" do
    url "https://files.pythonhosted.org/packages/09/84/c77ec45e084907e128710e08f5d7926723d7a67ccbebf27089309118807d/pynvim-0.5.2.tar.gz"
    sha256 "734a2432db8683519f58572617528ecb4a2f321bc7b27f034b3f9b2322c15615"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/9e/8b/dc1773e8e5d07fd27c1632c45c1de856ac3dbf09c0147f782ca6d990cf15/setuptools-80.7.1.tar.gz"
    sha256 "f6ffc5f0142b1bd8d0ca94ee91b30c0ca862ffd50826da1ea85258a06fd94552"
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
