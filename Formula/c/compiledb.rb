class Compiledb < Formula
  include Language::Python::Virtualenv

  desc "Generate a Clang compilation database for Make-based build systems"
  homepage "https://github.com/nickdiego/compiledb"
  url "https://files.pythonhosted.org/packages/0e/62/d0fc807871757841c32e6fbe433ebad422528a468336a0cf82fea226f41d/compiledb-0.10.7.tar.gz"
  sha256 "97752d8810b6977654a11a22cdc41bf6b71473bcdb5da312bc135f36d6af8271"
  license "GPL-3.0-or-later"
  head "https://github.com/nickdiego/compiledb.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "be28658b5cf0b082588b3ab1e46a5f76327e79efb90c417ded660671559de3ff"
  end

  depends_on "python@3.14"

  resource "bashlex" do
    url "https://files.pythonhosted.org/packages/76/60/aae0bb54f9af5e0128ba90eb83d8d0d506ee8f0475c4fdda3deeda20b1d2/bashlex-0.18.tar.gz"
    sha256 "5bb03a01c6d5676338c36fd1028009c8ad07e7d61d8a1ce3f513b7fff52796ee"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
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
