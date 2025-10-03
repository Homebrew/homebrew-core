class Pyparsing < Formula
  include Language::Python::Virtualenv

  desc "Classes and methods to define and execute parsing grammars"
  homepage "https://github.com/pyparsing/pyparsing"
  url "https://files.pythonhosted.org/packages/f2/a5/181488fc2b9d093e3972d2a472855aae8a03f000592dbfce716a512b3359/pyparsing-3.2.5.tar.gz"
  sha256 "2df8d5b7b2802ef88e8d016a2eb9c7aeaa923529cd251ed0fe4608275d4105b6"
  license "MIT"

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      from pyparsing import Word, alphas
      greet = Word(alphas) + "," + Word(alphas) + "!"
      hello = "Hello, World!"
      print(hello, "->", greet.parse_string(hello))
    PYTHON
    assert_equal "Hello, World! -> ['Hello', ',', 'World', '!']", shell_output("#{libexec}/bin/python test.py").chomp
  end
end
