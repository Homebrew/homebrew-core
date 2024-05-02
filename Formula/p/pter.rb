class Pter < Formula
  include Language::Python::Virtualenv

  desc "Your console and graphical UI to manage your todo.txt file(s)"
  homepage "https://vonshednob.cc/pter/"
  url "https://files.pythonhosted.org/packages/74/76/5d98cd47381f43de106359970a40ab2c19e7e7809de0c470ca36ff3935c2/pter-3.16.1.tar.gz"
  sha256 "dff43cdc603df7ad8f202c360881156c455ae867db39a0de03f340afa316eea7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "54b03754782be91d45347acec918d233c1b044c919ee8039b366192771ae8425"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "54b03754782be91d45347acec918d233c1b044c919ee8039b366192771ae8425"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54b03754782be91d45347acec918d233c1b044c919ee8039b366192771ae8425"
    sha256 cellar: :any_skip_relocation, sonoma:         "54b03754782be91d45347acec918d233c1b044c919ee8039b366192771ae8425"
    sha256 cellar: :any_skip_relocation, ventura:        "54b03754782be91d45347acec918d233c1b044c919ee8039b366192771ae8425"
    sha256 cellar: :any_skip_relocation, monterey:       "54b03754782be91d45347acec918d233c1b044c919ee8039b366192771ae8425"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91ff47582bf3c20090512795012ee2459af5addc1ce1cd6436eaa8cc5e8c7278"
  end

  depends_on "python@3.12"

  resource "cursedspace" do
    url "https://files.pythonhosted.org/packages/cd/3b/72657c9e867dd5034814dcea21b1128a70a1b8427e48c7de8b3b9ea3dd93/cursedspace-1.5.2.tar.gz"
    sha256 "21043f80498db9a79d5ee1bb52229fd28ad8871a360601c8f9120ff9dadc2aec"
  end

  resource "pytodotxt" do
    url "https://files.pythonhosted.org/packages/51/18/a8f4d15eb31bcde441b0ec090c5d97c435beabc9620199e7f90d2f5ad1af/pytodotxt-1.5.0.tar.gz"
    sha256 "99be359438c52e0c4fc007e11a89f5a03af00fc6851a6ba7070dfe0e00189009"
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
