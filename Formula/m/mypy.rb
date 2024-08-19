class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/b6/9c/a4b3bda53823439cf395db8ecdda6229a83f9bf201714a68a15190bb2919/mypy-1.11.1.tar.gz"
  sha256 "f404a0b069709f18bbdb702eb3dcfe51910602995de00bd39cea3050b5772d08"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ba351a4db27187c28cb95ca5f807d081f37c18a858418979de71cff779b188a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e80d5ead2cd0febc0e450b2f310c77269f835d8f21636641f2e5280fb659fd88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "655f309b2c150f0550b9d3145930350f2585d6351d5e85b3caf151c8937cf2bc"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b57dafba20349970cebd1b28daa4c9325d393a119e14dd920608bce082f247e"
    sha256 cellar: :any_skip_relocation, ventura:        "468afe3c556cefe9ff5610055ae5158fd96278001a316b9c2e2c4a51ac7d92cb"
    sha256 cellar: :any_skip_relocation, monterey:       "e8866882116cb267ca0cdd37695f4e411548c8dbd313ffb99ed6a5de4d71873a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e340316e2df8bc626fed08053330b5c6057bd9872fafc5f2cb3caf4226fdff1e"
  end

  depends_on "python@3.12"

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/98/a4/1ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3f/mypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  def install
    ENV["MYPY_USE_MYPYC"] = "1"
    ENV["MYPYC_OPT_LEVEL"] = "3"
    virtualenv_install_with_resources
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def p() -> None:
        print('hello')
      a = p()
    EOS
    output = pipe_output("#{bin}/mypy broken.py 2>&1")
    assert_match '"p" does not return a value', output

    output = pipe_output("#{bin}/mypy --version 2>&1")
    assert_match "(compiled: yes)", output
  end
end
