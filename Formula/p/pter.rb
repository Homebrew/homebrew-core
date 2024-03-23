class Pter < Formula
  include Language::Python::Virtualenv

  desc "Your console and graphical UI to manage your todo.txt file(s)"
  homepage "https://vonshednob.cc/pter/"
  url "https://files.pythonhosted.org/packages/30/1c/e20ba37fb6a77cf722675211823611206c1398971d48f7930265e3c42567/pter-3.16.0.tar.gz"
  sha256 "c58cc4947f61dbaf7782f98c2733d22ed6803eba37a793c89ed1f1bc11c27b65"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "12c78279f3ae344434f7848bc5190a34662f37912fcb845a97aaae8802489928"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dfae7583c1f892a93c8e263327b967b17450b99bab72b3671bb7a5f5aff4c759"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "747a09614c534cb17faec7d55b2956ae02019b6463eefd2b94b5c2c2b63cb681"
    sha256 cellar: :any_skip_relocation, sonoma:         "d88465a5b082ddc193838a7385b91239e3727a5f75a7a00cdc45bd405d369e13"
    sha256 cellar: :any_skip_relocation, ventura:        "aef0545f72b0dd32803179563c5d8f1d2c16da1aaba1df247ecd4d28969777fe"
    sha256 cellar: :any_skip_relocation, monterey:       "59a8d77175f4749e1549bedf53665dd9b083053a4f47fbbe7042c28433d66d21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a3c5eb16faf5999cf4a06369640a21f3a2857f58882e2c47ff40dad8c80984f"
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
