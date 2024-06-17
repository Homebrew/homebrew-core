class Pter < Formula
  include Language::Python::Virtualenv

  desc "Your console and graphical UI to manage your todo.txt file(s)"
  homepage "https://vonshednob.cc/pter/"
  url "https://files.pythonhosted.org/packages/75/98/e76e8eb4ba4b34b50b7fe5c0e11ed852e9fe7a3f2c75bd420d66d3023bde/pter-3.16.3.tar.gz"
  sha256 "c5034d48f0b6a4fbeb73fbfb8fe2cabddad15578d261a2870648f1f819d49cc1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ef488618246d711db4f2dd7f0360363a923f80f5185ec9887158e6a364a2e47"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "298e3130d2cfb08b42daa6fafdecfbf60784a385800f4896f44e61713c456a02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85cda51b23abbe678aa4f5a5a940388a2cbfb33ce822ebe058d1eab14c10715f"
    sha256 cellar: :any_skip_relocation, sonoma:         "19b89d24e53acd380b57e8100158210205a8c28c2d57e9713d3cdcca27a948ca"
    sha256 cellar: :any_skip_relocation, ventura:        "5c656b238f5ded79cb86e386841ac1ac7af5b36200b8357ff06a71dcc38405d0"
    sha256 cellar: :any_skip_relocation, monterey:       "697807fb0fea387ca8eb85e7e78c35624168c70a01d819f0137a22d3743bab24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da14e5c88bbf3b4504266bc6e8e1af29a0692cdc3e9259ab185a9b316f4bc9cd"
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
