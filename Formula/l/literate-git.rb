class LiterateGit < Formula
  include Language::Python::Virtualenv

  desc "Render hierarchical git repositories into HTML"
  homepage "https://github.com/bennorth/literate-git"
  url "https://files.pythonhosted.org/packages/67/0e/e37f96177ca5227416bbf06e96d23077214fbb3968b02fe2a36c835bf49e/literategit-0.5.1.tar.gz"
  sha256 "3db9099c9618afd398444562738ef3142ef3295d1f6ce56251ba8d22385afe44"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c78fca9768aa28cc91c7fcd0fdb6f74e6d2edab8ff267912ee079a0d13667188"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97beb2e869acd67d690d1a51a32f49366b73e3cc6aaad8ea0e7384b8ee493645"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "72e3eb02cd1b9f4656d7c2a1cc941f9c61caebc5c3d134f18364bc0cd896f889"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d21c7e6ada9f49184787a19d7fd67dda9e933e3c267f5af318ad90fad3a9aa4"
    sha256 cellar: :any_skip_relocation, ventura:       "4719c71162e17145fcafbd29a0b78341fbba740191ea2b4533072350560db2dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44e546f0a8bcc036eb4925142d5f5c60b41ac909d6bba3cd89b21e800a02fb33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98a17d82f86fca6482e0d1ef72023b9f8ba90837247c7116661a2c8b8cc9e001"
  end

  depends_on "pygit2"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkgconf" => :build
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markdown2" do
    url "https://files.pythonhosted.org/packages/44/52/d7dcc6284d59edb8301b8400435fbb4926a9b0f13a12b5cbaf3a4a54bb7b/markdown2-2.5.3.tar.gz"
    sha256 "4d502953a4633408b0ab3ec503c5d6984d1b14307e32b325ec7d16ea57524895"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  def install
    # The source doesn't have a valid SOURCE_DATE_EPOCH, so here we set default.
    ENV["SOURCE_DATE_EPOCH"] = "1451574000"

    virtualenv_install_with_resources
  end

  test do
    system "git", "init"
    (testpath/"foo.txt").write "Hello"
    system "git", "add", "foo.txt"
    system "git", "commit", "-m", "foo"
    system "git", "branch", "one"
    (testpath/"bar.txt").write "World"
    system "git", "add", "bar.txt"
    system "git", "commit", "-m", "bar"
    system "git", "branch", "two"
    (testpath/"create_url.py").write <<~PYTHON
      class CreateUrl:
        @staticmethod
        def result_url(sha1):
          return ''
        @staticmethod
        def source_url(sha1):
          return ''
    PYTHON
    assert_match "<!DOCTYPE html>",
      shell_output("git literate-render test one two create_url.CreateUrl")
  end
end
