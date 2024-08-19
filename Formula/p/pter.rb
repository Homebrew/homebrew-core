class Pter < Formula
  include Language::Python::Virtualenv

  desc "Your console and graphical UI to manage your todo.txt file(s)"
  homepage "https://vonshednob.cc/pter/"
  url "https://files.pythonhosted.org/packages/9d/24/636d437b89bebe272f162e310794f7e350e419b2db1082cbc84a6f7faa06/pter-3.17.0.tar.gz"
  sha256 "2f961f4e0e3152f215df46c06914f3e343a9e2751b0e121a5bf5bf9d4394bb1c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b19f0ebdb88dcf028e7b6a474ea7eecf7238fdaa0dcd3023dfca494c0f510c06"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b19f0ebdb88dcf028e7b6a474ea7eecf7238fdaa0dcd3023dfca494c0f510c06"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b19f0ebdb88dcf028e7b6a474ea7eecf7238fdaa0dcd3023dfca494c0f510c06"
    sha256 cellar: :any_skip_relocation, sonoma:         "b19f0ebdb88dcf028e7b6a474ea7eecf7238fdaa0dcd3023dfca494c0f510c06"
    sha256 cellar: :any_skip_relocation, ventura:        "b19f0ebdb88dcf028e7b6a474ea7eecf7238fdaa0dcd3023dfca494c0f510c06"
    sha256 cellar: :any_skip_relocation, monterey:       "b19f0ebdb88dcf028e7b6a474ea7eecf7238fdaa0dcd3023dfca494c0f510c06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9dde6fe5093b52f39fcd5362081c8895f0ac5443d2f29eb65b299f430708ffb"
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
