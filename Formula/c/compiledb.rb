class Compiledb < Formula
  include Language::Python::Virtualenv

  desc "Generate a Clang compilation database for Make-based build systems"
  homepage "https://github.com/nickdiego/compiledb"
  url "https://files.pythonhosted.org/packages/0e/62/d0fc807871757841c32e6fbe433ebad422528a468336a0cf82fea226f41d/compiledb-0.10.7.tar.gz"
  sha256 "97752d8810b6977654a11a22cdc41bf6b71473bcdb5da312bc135f36d6af8271"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/nickdiego/compiledb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7f6e5ece68a904147b3799e19de9f2cc9fbb6a53240ac3292bb7c10d8bdc1158"
  end

  depends_on "python@3.14"

  resource "bashlex" do
    url "https://files.pythonhosted.org/packages/76/60/aae0bb54f9af5e0128ba90eb83d8d0d506ee8f0475c4fdda3deeda20b1d2/bashlex-0.18.tar.gz"
    sha256 "5bb03a01c6d5676338c36fd1028009c8ad07e7d61d8a1ce3f513b7fff52796ee"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"compiledb", shell_parameter_format: :click)
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
