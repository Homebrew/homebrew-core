class Pter < Formula
  include Language::Python::Virtualenv

  desc "Your console and graphical UI to manage your todo.txt file(s)"
  homepage "https://vonshednob.cc/pter/"
  url "https://files.pythonhosted.org/packages/7c/b3/9d527cabc89e376f05d7c1047f82a8c9eb9f1f40d1ca8f3830bd52917d1b/pter-3.20.1.tar.gz"
  sha256 "4f1c480d0930d93d3d3f2d986ecca1456a00ded21cf0feaf4041cc506cc336ed"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "50ede2858502198b2cf27291ddf5e09c360268f34dcb31c1d2a426c5d9dd93ba"
  end

  depends_on "python@3.13"

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
