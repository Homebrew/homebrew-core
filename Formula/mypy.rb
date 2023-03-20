class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/62/54/be80f8d01f5cf72f774a77f9f750527a6fa733f09f78b1da30e8fa3914e6/mypy-1.1.1.tar.gz"
  sha256 "ae9ceae0f5b9059f33dbc62dea087e942c0ccab4b7a003719cb70f9b8abfa32f"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c22b15c3ab0bdca2523147662cc68db624ff06072e0064006fcf45b46f92e98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08817ff7eef829999f6bd904409bb498230e7588f0dc4c555c6b8269fcaa2182"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9664671d5dada43a74419381415033b02a16fdd643cfe7be166072cf4aa636ff"
    sha256 cellar: :any_skip_relocation, ventura:        "4314ec652314099aa83635c1738ac9605bba4ed4a8c0b0b1280d1651bf60eca3"
    sha256 cellar: :any_skip_relocation, monterey:       "14f818bf65550dc8afcde0f7df4526ed1f0221ff8caa3cf013b9eff39f5c6c8a"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ea3387188ed42165118663f0aaab17cb87b98a9fb7788dc3150bfa9279627d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35e2f11f53066f4aa4c45dd34b907979c02d8f084d2ac86e1a6dd4670b0024e5"
  end

  depends_on "python@3.11"

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/98/a4/1ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3f/mypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/d3/20/06270dac7316220643c32ae61694e451c98f8caf4c8eab3aa80a2bedf0df/typing_extensions-4.5.0.tar.gz"
    sha256 "5cb5f4a79139d699607b3ef622a1dedafa84e115ab0024e0d9c044a9479ca7cb"
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
