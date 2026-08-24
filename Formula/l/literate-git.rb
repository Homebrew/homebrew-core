class LiterateGit < Formula
  include Language::Python::Virtualenv

  desc "Render hierarchical git repositories into HTML"
  homepage "https://github.com/bennorth/literate-git"
  url "https://files.pythonhosted.org/packages/67/36/c0d78cde182822b1df78b3f4b1db3a5d21bc80663557d0373d7e61a75747/literategit-0.5.5.tar.gz"
  sha256 "8dbe0930f0b915caedd53411aec063961ff6999fac812e5d80976e65a89661cc"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ccf9acc84587e2bf36b4039edb339affb921841e5f85823e8683f06107e2907"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54872f5dbc3809592e771741536cc33adf0bc0285bef0fed22981a4cdbd8404f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d128a916ca18cc7cc0d9e6a45cd170a93af0ca3911aa8a1075d8f0463ac56cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "90f60838a472927a1b16a2520b5783a91496426f2aab5d1f6c7d12478e34c1bb"
    sha256 cellar: :any,                 arm64_linux:   "8b4d21fc4f174e6876c0752e6d59a7ead8c6b99522b88f80b2ba46dfbeac18dd"
    sha256 cellar: :any,                 x86_64_linux:  "18480486d0c76df598d8f41a90ead8d82403c5da96ba65f1685b61e6d5b2d2d9"
  end

  depends_on "pkgconf" => :build
  depends_on "pygit2" => :no_linkage
  depends_on "python@3.14"

  uses_from_macos "libffi"

  pypi_packages exclude_packages: "pygit2"

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markdown2" do
    url "https://files.pythonhosted.org/packages/e4/ae/07d4a5fcaa5509221287d289323d75ac8eda5a5a4ac9de2accf7bbcc2b88/markdown2-2.5.5.tar.gz"
    sha256 "001547e68f6e7fcf0f1cb83f7e82f48aa7d48b2c6a321f0cd20a853a8a2d1664"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  def install
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
