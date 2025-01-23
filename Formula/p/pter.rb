class Pter < Formula
  include Language::Python::Virtualenv

  desc "Your console and graphical UI to manage your todo.txt file(s)"
  homepage "https://vonshednob.cc/pter/"
  url "https://files.pythonhosted.org/packages/8c/5d/1ae0025d600531a90d2ef7bce00d72b9600a8b6ad32da0a139b0624458cc/pter-3.19.2.tar.gz"
  sha256 "be98f704797e0ad06713c43dfc2e14f8e7675ba5353b430de09b943265b06980"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "64fa8f1f54e9e39c989f99c44df9b4e2cac8bab975e52401ffed33ec800f147d"
  end

  depends_on "python@3.13"

  resource "cursedspace" do
    url "https://files.pythonhosted.org/packages/cd/3b/72657c9e867dd5034814dcea21b1128a70a1b8427e48c7de8b3b9ea3dd93/cursedspace-1.5.2.tar.gz"
    sha256 "21043f80498db9a79d5ee1bb52229fd28ad8871a360601c8f9120ff9dadc2aec"
  end

  resource "pytodotxt" do
    url "https://files.pythonhosted.org/packages/be/b7/dad26d5ec8ff4c0e6ed37414f5d5de53c3d9ceab67e077606e5a1ed44ea0/pytodotxt-2.0.0.post1.tar.gz"
    sha256 "bdbdfc17840b18903d37784d1c58c49fdd8127323d9b6234e3992a74eea80310"
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
