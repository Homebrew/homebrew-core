class Pter < Formula
  include Language::Python::Virtualenv

  desc "Your console and graphical UI to manage your todo.txt file(s)"
  homepage "https://vonshednob.cc/pter/"
  url "https://files.pythonhosted.org/packages/28/b7/007b72b2f7fcf1fdc2c41104abc5cc23194c0842e68736fabb0ad6cd5e2b/pter-3.10.0.tar.gz"
  sha256 "17843623e7a8b81ff7d191507e464b47c880377f6ebf42bb6cdbe3604ebe9722"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d91d21008f89737ecbedb165d9e9686c44da07d3899dc9c1d784498c391a11c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5efee3feb4464197ba9cd24ef2535cd0a3d39393ae97e1173c84785a900cdc79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f8dd75a355e3b4296e1b88a67cfcef17d3b87d6b8189a630e10a4f6c1f5a465"
    sha256 cellar: :any_skip_relocation, sonoma:         "4120a87c1ce0f2dc2d6668f7bc046b41f528643b75fc672b70069ec4ec91d7b3"
    sha256 cellar: :any_skip_relocation, ventura:        "6ec8be6cff9eb8bec17a88cb1cd7da445643ec05b7755c4dca25b7628592449f"
    sha256 cellar: :any_skip_relocation, monterey:       "af19a972a8b017e2f410197fd3f2b1d2233cf78a4ec8d3a8e5fe6ecc089b3f1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4806f19c201a0b428d9a2ebc743096742c7e96a2d061eef14fad35fdcb892006"
  end

  # upstream py3.12 support issue, https://github.com/vonshednob/pter/issues/30
  depends_on "python@3.11"

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
