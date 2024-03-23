class Pter < Formula
  include Language::Python::Virtualenv

  desc "Your console and graphical UI to manage your todo.txt file(s)"
  homepage "https://vonshednob.cc/pter/"
  url "https://files.pythonhosted.org/packages/30/1c/e20ba37fb6a77cf722675211823611206c1398971d48f7930265e3c42567/pter-3.16.0.tar.gz"
  sha256 "c58cc4947f61dbaf7782f98c2733d22ed6803eba37a793c89ed1f1bc11c27b65"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b43a1ba014931b0a9253408ceee28dbfd5bb67348a5cd827cc95e6af911f82a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b43a1ba014931b0a9253408ceee28dbfd5bb67348a5cd827cc95e6af911f82a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b43a1ba014931b0a9253408ceee28dbfd5bb67348a5cd827cc95e6af911f82a"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b43a1ba014931b0a9253408ceee28dbfd5bb67348a5cd827cc95e6af911f82a"
    sha256 cellar: :any_skip_relocation, ventura:        "8b43a1ba014931b0a9253408ceee28dbfd5bb67348a5cd827cc95e6af911f82a"
    sha256 cellar: :any_skip_relocation, monterey:       "8b43a1ba014931b0a9253408ceee28dbfd5bb67348a5cd827cc95e6af911f82a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83e4c24bcdc59254a423e550a67728361c253a66476c33afd773483d6787ba95"
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
