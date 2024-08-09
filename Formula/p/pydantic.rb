class Pydantic < Formula
  include Language::Python::Virtualenv

  desc "Data parsing and validation using Python type hints"
  homepage "https://docs.pydantic.dev/latest/"
  url "https://files.pythonhosted.org/packages/8c/99/d0a5dca411e0a017762258013ba9905cd6e7baa9a3fd1fe8b6529472902e/pydantic-2.8.2.tar.gz"
  sha256 "6f62c13d067b0755ad1c21a34bdd06c0c12625a22b0fc09c6b149816604f7c2a"
  license "MIT"

  depends_on "rust" => :build
  depends_on "python@3.12"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/12/e3/0d5ad91211dba310f7ded335f4dad871172b9cc9ce204f5a56d76ccd6247/pydantic_core-2.20.1.tar.gz"
    sha256 "26ca695eeee5f9f1aeeb211ffc12f10bcb6f71e2989988fda61dabd65db878d4"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  def python3
    which("python3.12")
  end

  def install
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources
    venv.pip_install_and_link buildpath
    site_packages = Language::Python.site_packages(python3)
    (prefix/site_packages/"homebrew-pydantic.pth").write venv.site_packages
  end

  test do
    (testpath/"test_pydantic.py").write <<~EOS
      from pydantic import BaseModel, ValidationError

      class Person(BaseModel):
        name: str
        age: int

      person = Person(name="Alice", age=30)
      assert person.name == "Alice"
      assert person.age == 30

      try:
        invalid_person = Person(name="Bob", age="thirty")
      except ValidationError:
        print("ValidationError raised as expected")
      else:
        raise AssertionError("ValidationError was not raised")
    EOS

    output = shell_output("#{python3} test_pydantic.py")
    assert_match "ValidationError raised as expected", output
  end
end
