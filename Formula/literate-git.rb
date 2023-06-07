class LiterateGit < Formula
  include Language::Python::Virtualenv

  desc "Render hierarchical git repositories into HTML"
  homepage "https://github.com/bennorth/literate-git"
  url "https://github.com/bennorth/literate-git/archive/v0.3.1.tar.gz"
  sha256 "f1dec77584236a5ab2bcee9169e16b5d976e83cd53d279512136bdc90b04940a"
  license "GPL-3.0-or-later"
  revision 13

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31e0c7b5e24fa754a3a9c093101535e64af4a5e00618fdfe4eea06afcca8ad2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "268a50887b3929b544fed71277bd93e65c8285fed93d3d81d70b30391fae72d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2f80196bf354dc363f82bfacc81bb8872deee508d1f8b2b3fec34d7d64e3c7a"
    sha256 cellar: :any_skip_relocation, ventura:        "c4270a2bc1b79e32660ad64483746ef2c734a898edd98453976a468903b2c93f"
    sha256 cellar: :any_skip_relocation, monterey:       "68117dad13005e6bbb6ec4b3e6759137d5a6c2cc9a1a3dc2081cdf4a39b6c637"
    sha256 cellar: :any_skip_relocation, big_sur:        "9127986e4e878f5711f623f7198d10718e916528ebf81d2d8f70cf901e209fbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfdb32662011363420758133f66f4837af84e07ebdae57cf9416057eb66bf815"
  end

  depends_on "pygit2"
  depends_on "python@3.11"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/4f/e7/65300e6b32e69768ded990494809106f87da1d436418d5f1367ed3966fd7/Jinja2-2.11.3.tar.gz"
    sha256 "a6d58433de0ae800347cab1fa3043cebbabe8baa9d29e668f1c768cb87a333c6"
  end

  resource "markdown2" do
    url "https://files.pythonhosted.org/packages/2b/26/1dd47bdf8adb98e1807b2283a88d6d4379911a2e1a1da266739c038ef8e2/markdown2-2.4.3.tar.gz"
    sha256 "412520c7b6bba540c2c2067d6be3a523ab885703bf6a81d93963f848b55dfb9a"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/b9/2e/64db92e53b86efccfaea71321f597fa2e1b2bd3853d8ce658568f7a13094/MarkupSafe-1.1.1.tar.gz"
    sha256 "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/cb/9f/27d4844ac5bf158a33900dbad7985951e2910397998e85712da03ce125f0/Pygments-2.5.2.tar.gz"
    sha256 "98c8aa5a9f778fcd1026a17361ddaf7330d1b7c62ae97c3bb0ae73e0b9b6b0fe"
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
    (testpath/"create_url.py").write <<~EOS
      class CreateUrl:
        @staticmethod
        def result_url(sha1):
          return ''
        @staticmethod
        def source_url(sha1):
          return ''
    EOS
    assert_match "<!DOCTYPE html>",
      shell_output("git literate-render test one two create_url.CreateUrl")
  end
end
