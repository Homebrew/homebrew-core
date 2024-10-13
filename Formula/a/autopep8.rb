class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/6c/52/65556a5f917a4b273fd1b705f98687a6bd721dbc45966f0f6687e90a18b0/autopep8-2.3.1.tar.gz"
  sha256 "8d6c87eba648fdcfc83e29b788910b8643171c395d9c4bcf115ece035b9c9dda"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "e9743fa4892acbd3dd30a24f82e52df2db9cc7bd20e5d3e0c43f2c37de60e02f"
  end

  depends_on "python@3.13"

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/43/aa/210b2c9aedd8c1cbeea31a50e42050ad56187754b34eb214c46709445801/pycodestyle-2.12.1.tar.gz"
    sha256 "6838eae08bbce4f6accd5d5572075c63626a15ee3e6f842df996bf62f6d73521"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/autopep8 -", "x='homebrew'")
    assert_equal "x = 'homebrew'", output.strip
  end
end
