class LiterateGit < Formula
  include Language::Python::Virtualenv

  desc "Render hierarchical git repositories into HTML"
  homepage "https://github.com/bennorth/literate-git"
  url "https://files.pythonhosted.org/packages/3f/83/8891468bd2e70fdd89e50bcdb5249adfca85fa29d08b99a97e0a899d2044/literategit-0.5.6.tar.gz"
  sha256 "9cdb07088fe7be59d4f24239b90b9c041d8c2c42de7af3c53681e8272f9010b6"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "97db96a4331803bf21206e93354b8581084d70bb15553ee5782443b087d03b55"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e67c10ebe0b1ff85e7ad49fbf4ff7c93a288b414404eeadcef34b58ce534fc9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fa64f0cf3a50fb9ed08bca790fce7724ecc850993b455d3babea4bd1b2f35abd"
    sha256 cellar: :any,                 arm64_linux:       "e126987f8e3feed492ddb2c83f77408a1c3869d393bf92087404956611d0979b"
    sha256 cellar: :any,                 x86_64_linux:      "69e5db03a0a03ea0417446ec8af1b24de7fdc5e95c2598c400260a56501540b8"
  end

  depends_on "pkgconf" => :build
  depends_on "pygit2" => :no_linkage
  depends_on "python@3.15"

  uses_from_macos "libffi"

  pypi_packages exclude_packages: "pygit2"

  resource "click" do
    url "https://files.pythonhosted.org/packages/45/37/edbf1b0707709013c0cf2e8317e03d97ed29bf4cac709fe328904ae92a38/click-8.5.1.tar.gz"
    sha256 "9bbfada76703fd1d784b83eea012e3e8c6a001a876543ef104fa56aaaeb072b4"
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
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
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
