class Pter < Formula
  include Language::Python::Virtualenv

  desc "Your console and graphical UI to manage your todo.txt file(s)"
  homepage "https://vonshednob.cc/pter/"
  url "https://files.pythonhosted.org/packages/f3/8c/0ba867644dc8cf806de997207cfb284cf3cf9bd5960940fcadc146bd998c/pter-3.18.0.tar.gz"
  sha256 "a0a9af10c2f54f37dcce686f8f93316cf7c114b3256c13fdc1aa74d61a86fcd4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2651344c0e659727997fd280b7a45726db387272a9490bf81ff50503341cd122"
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
