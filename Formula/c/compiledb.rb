class Compiledb < Formula
  include Language::Python::Virtualenv

  desc "Generate a Clang compilation database for Make-based build systems"
  homepage "https://github.com/nickdiego/compiledb"
  url "https://files.pythonhosted.org/packages/0e/62/d0fc807871757841c32e6fbe433ebad422528a468336a0cf82fea226f41d/compiledb-0.10.7.tar.gz"
  sha256 "97752d8810b6977654a11a22cdc41bf6b71473bcdb5da312bc135f36d6af8271"
  license "GPL-3.0-or-later"
  head "https://github.com/nickdiego/compiledb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e1ba5487728c29b4d7c4c01a7d359a6d7b6879986bb58d9d1798b98a233fbde7"
  end

  depends_on "python@3.13"

  resource "bashlex" do
    url "https://files.pythonhosted.org/packages/76/60/aae0bb54f9af5e0128ba90eb83d8d0d506ee8f0475c4fdda3deeda20b1d2/bashlex-0.18.tar.gz"
    sha256 "5bb03a01c6d5676338c36fd1028009c8ad07e7d61d8a1ce3f513b7fff52796ee"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"compiledb", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    (testpath/"Makefile").write <<~MAKE
      all:
      	cc main.c -o test
    MAKE
    (testpath/"main.c").write <<~C
      int main(void) { return 0; }
    C

    system bin/"compiledb", "-n", "make"
    assert_path_exists testpath/"compile_commands.json", "compile_commands.json should be created"
  end
end
