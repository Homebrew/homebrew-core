class LiterateGit < Formula
  include Language::Python::Virtualenv

  desc "Render hierarchical git repositories into HTML"
  homepage "https://github.com/bennorth/literate-git"
  url "https://files.pythonhosted.org/packages/3f/83/8891468bd2e70fdd89e50bcdb5249adfca85fa29d08b99a97e0a899d2044/literategit-0.5.6.tar.gz"
  sha256 "9cdb07088fe7be59d4f24239b90b9c041d8c2c42de7af3c53681e8272f9010b6"
  license "GPL-3.0-or-later"

  bottle do
    manifest_sha256 "40fba5aa6389c9e9e606ceaf3564b0786f079d21e69090851dbc3d374b7b0c93"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "070c1d7d4e588a76e1a610e99b03b3dcc712be3fa7e573f772957f32351d937e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a961d660e284c741c141917219102be4aca044f901ccbb8df498bd2a171b5fd2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eb972e9c77eecbaaa25dfc7658cb9d18f7c72c2ab98066768f644e9ab52c6a11"
    sha256 cellar: :any,                 arm64_linux:       "c72bcbaa15a7b709a3b697d1f26f6ba7826682493340f8dbcd7ae3932c0e288b"
    sha256 cellar: :any,                 x86_64_linux:      "43714ded0a7da75ff5a8203d7834f2db5131f4be06f15efa65ea23018dc99dc3"
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
