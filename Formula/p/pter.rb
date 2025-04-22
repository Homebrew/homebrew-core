class Pter < Formula
  include Language::Python::Virtualenv

  desc "Your console and graphical UI to manage your todo.txt file(s)"
  homepage "https://vonshednob.cc/pter/"
  url "https://files.pythonhosted.org/packages/e8/79/8e37be56dcd19050e141d6c10584009b7c1a70df5703f47c15f39c39efe1/pter-3.20.0.tar.gz"
  sha256 "5cc67ae45fd461dd11a61af4a0749d443fdec2a3c8f12f414a96237c41a66b18"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0c2ef26856fcfeb4c7bc4d587f1a413a7da734ec2c30409286ea987c21099b88"
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
