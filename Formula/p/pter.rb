class Pter < Formula
  include Language::Python::Virtualenv

  desc "Your console and graphical UI to manage your todo.txt file(s)"
  homepage "https://vonshednob.cc/pter/"
  url "https://files.pythonhosted.org/packages/4b/cf/227905ded81b4516d836086cc41bd2d8200e83b9eacbbfdb594a47a4108a/pter-3.23.1.tar.gz"
  sha256 "c5afba3fdea2872f2a9664bd7e72e86f3a15029b6a1e3e23640a1f357beb1f95"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9e4a6bf7ffd9142af6f683ab4e7e423ccb0b9a0354f2a312e95977614f1c2983"
  end

  depends_on "python@3.14"

  resource "cursedspace" do
    url "https://files.pythonhosted.org/packages/cd/3b/72657c9e867dd5034814dcea21b1128a70a1b8427e48c7de8b3b9ea3dd93/cursedspace-1.5.2.tar.gz"
    sha256 "21043f80498db9a79d5ee1bb52229fd28ad8871a360601c8f9120ff9dadc2aec"
  end

  resource "pytodotxt" do
    url "https://files.pythonhosted.org/packages/d8/59/5449ac80f2a85c1156d6226b841497577563585fdeae8115f17e9abdea65/pytodotxt-3.1.0.tar.gz"
    sha256 "00ed7e6ca22a8d7dc0f8f0c3424765209d20808a76c06963a1c43d917506e5fe"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    PTY.spawn(bin/"pter", "todo.txt") do |r, w, _pid|
      w.write "n"         # Create new task
      w.write "some task" # Task description
      w.write "\r"        # Confirm
      w.write "q"         # Quit
      r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
    assert_match "some task", (testpath/"todo.txt").read
  end
end
