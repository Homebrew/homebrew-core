class Pter < Formula
  include Language::Python::Virtualenv

  desc "Your console and graphical UI to manage your todo.txt file(s)"
  homepage "https://vonshednob.cc/pter/"
  url "https://files.pythonhosted.org/packages/1d/b5/4f0a60f67d9549e679aff1715aeb9c2ccedfe23ec25de544714f94de0b9b/pter-3.21.0.tar.gz"
  sha256 "98fa3dbc35eeea48b3c37f893988e0cdba2ff407d2988a0696683995baf58f5d"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "e7dece803dab0fc1f6594c876070ee3abe27bfc2f99e80004cb6e6d395e6ee06"
  end

  depends_on "python@3.14"

  resource "cursedspace" do
    url "https://files.pythonhosted.org/packages/cd/3b/72657c9e867dd5034814dcea21b1128a70a1b8427e48c7de8b3b9ea3dd93/cursedspace-1.5.2.tar.gz"
    sha256 "21043f80498db9a79d5ee1bb52229fd28ad8871a360601c8f9120ff9dadc2aec"
  end

  resource "pytodotxt" do
    url "https://files.pythonhosted.org/packages/ac/72/8948cd01bd2c9c5a1c5a83cb42856b9db8118cd2ffc51cc934a8b53b421c/pytodotxt-3.0.0.tar.gz"
    sha256 "6d24d9d66120e525b30c9239f26f09fdbb0ebf4654a3b4453a656d25387a8bff"
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
