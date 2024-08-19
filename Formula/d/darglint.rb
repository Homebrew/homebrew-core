class Darglint < Formula
  include Language::Python::Virtualenv

  desc "Python docstring argument linter"
  homepage "https://github.com/terrencepreilly/darglint"
  url "https://files.pythonhosted.org/packages/d4/2c/86e8549e349388c18ca8a4ff8661bb5347da550f598656d32a98eaaf91cc/darglint-1.8.1.tar.gz"
  sha256 "080d5106df149b199822e7ee7deb9c012b49891538f14a11be681044f0bb20da"
  license "MIT"
  head "https://github.com/terrencepreilly/darglint.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fab11572b650056b2368d8080f6497ad5f507286e147089fa323fd3257a2801c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7de9e8485bfa9da6ac8741b977349f65ce6f27e4067c609d52f07449cc470d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "848f5aa7fd155b1a9c047e5b5c6f01dd57fd8dd69468b88d5fb3ffae3ba77687"
    sha256 cellar: :any_skip_relocation, ventura:        "f1a7962cd4b099e328025393476d02a6ab69f342ae7a99496aa3ec6927da5d8d"
    sha256 cellar: :any_skip_relocation, monterey:       "c1421450b1625a080b39a54a8721dcdef12bcfd35c04196e36df96da6be45720"
    sha256 cellar: :any_skip_relocation, big_sur:        "8fa0e26b846c3b2ef823e2b296b89fa4e194a490590573e2515b77347457c78e"
    sha256 cellar: :any_skip_relocation, catalina:       "50ff6168116a577d6b16edc02c4f71195aeb608234b64666d627dacaec0b0400"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf75b7da4e5b6fa72299af2179bcc3bf50cde731a7f7ac4463a819ea0884da79"
  end

  disable! date: "2023-09-25", because: :repo_archived

  depends_on "python@3.11"

  # Switch build-system to poetry-core to avoid rust dependency on Linux.
  # Remove when merged/released: https://github.com/terrencepreilly/darglint/pull/203
  patch do
    url "https://github.com/terrencepreilly/darglint/commit/aa10a220bbbce522bee2c986606a1650f1c2be1e.patch?full_index=1"
    sha256 "871a4790feabd4e6a5feb2d618ef5802dc3c9ecd47345c3ba2f9377068ba4fa7"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def bad_docstring(x):
        """nothing about x"""
        pass
    EOS
    output = pipe_output("#{bin}/darglint -v 2 broken.py 2>&1")
    assert_match "DAR101: Missing parameter(s) in Docstring: - x", output
  end
end
