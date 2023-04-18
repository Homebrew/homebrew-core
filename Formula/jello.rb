class Jello < Formula
  include Language::Python::Virtualenv

  desc "Filter JSON and JSON Lines data with Python syntax"
  homepage "https://github.com/kellyjonbrazil/jello"
  url "https://files.pythonhosted.org/packages/03/a7/1d48279706b63a5928cfb0dda5152bd27ce914da05d31008b2fc252165e1/jello-1.5.5.tar.gz"
  sha256 "a7bc8762867db5c479323e308bd1d6074b5d5b0cafe3fdf340481764c7851487"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae31403dc22c9149492ac4f0a3a9abc56f83ef2bb61bf3f0a5ee607df3cfec76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae31403dc22c9149492ac4f0a3a9abc56f83ef2bb61bf3f0a5ee607df3cfec76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae31403dc22c9149492ac4f0a3a9abc56f83ef2bb61bf3f0a5ee607df3cfec76"
    sha256 cellar: :any_skip_relocation, ventura:        "fdc8b952478c453f94f7e0411cfc013f34fb69e6f7bca0d5cc83aa6072f8ccef"
    sha256 cellar: :any_skip_relocation, monterey:       "fdc8b952478c453f94f7e0411cfc013f34fb69e6f7bca0d5cc83aa6072f8ccef"
    sha256 cellar: :any_skip_relocation, big_sur:        "fdc8b952478c453f94f7e0411cfc013f34fb69e6f7bca0d5cc83aa6072f8ccef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ee9461b48ef0b8db27872908112044b0f9c9e7bb9bc609ee3eca69d18f10ce9"
  end

  depends_on "pygments"
  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
    man1.install "man/jello.1"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/jello _.foo", "{\"foo\":1}")
  end
end
