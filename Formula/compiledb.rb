class Compiledb < Formula
  include Language::Python::Virtualenv

  desc "Generate a Clang compilation database for Make-based build systems"
  homepage "https://github.com/nickdiego/compiledb"
  url "https://github.com/nickdiego/compiledb/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "3f288e4897e2b17b4dd8070d3ad9e9fc627961faa4d0be29a78f6c619e055f36"
  license "GPL-3.0-or-later"

  depends_on "python@3.10"

  resource "click" do
    url "https://files.pythonhosted.org/packages/dd/cf/706c1ad49ab26abed0b77a2f867984c1341ed7387b8030a6aa914e2942a0/click-8.0.4.tar.gz"
    sha256 "8458d7b1287c5fb128c90e23381cf99dcde74beaf6c7ff6384ce84d6fe090adb"
  end

  resource "bashlex" do
    url "https://files.pythonhosted.org/packages/1b/57/8de844f7702f644382def6aee76c64da5a1acfbc22a23ffbc565e0ec69cd/bashlex-0.16.tar.gz"
    sha256 "dc6f017e49ce2d0fe30ad9f5206da9cd13ded073d365688c9fda525354e8c373"
  end

  resource "shutilwhich" do
    url "https://files.pythonhosted.org/packages/66/be/783f181594bb8bcfde174d6cd1e41956b986d0d8d337d535eb2555b92f8d/shutilwhich-1.1.0.tar.gz"
    sha256 "db1f39c6461e42f630fa617bb8c79090f7711c9ca493e615e43d0610ecb64dc6"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"Makefile").write <<~EOS
      all:
      	cc main.c -o test
    EOS
    (testpath/"main.c").write <<~EOS
      int main(void) { return 0; }
    EOS

    system "#{bin}/compiledb", "-n", "make"
    assert_predicate testpath/"compile_commands.json", :exist?, "compile_commands.json should be created"
  end
end
