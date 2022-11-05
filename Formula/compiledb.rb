class Compiledb < Formula
  include Language::Python::Virtualenv

  desc "Generate a Clang compilation database for Make-based build systems"
  homepage "https://github.com/nickdiego/compiledb"
  url "https://files.pythonhosted.org/packages/76/62/30fb04404b1d4a454f414f792553d142e8acc5da27fddcce911fff0fe570/compiledb-0.10.1.tar.gz"
  sha256 "06bb47dd1fa04de3a12720379ff382d40441074476db7c16a27e2ad79b7e966e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d82cc1ece9f88d70cd443b32bef3e71fa319982dfa0b876e55d00dde32f61db4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe4bddd8fb67d28ac1c9d10e0078dce97c7497d429f8736e12ee2f4cf4792e3a"
    sha256 cellar: :any_skip_relocation, monterey:       "a892459ea54ed2d3aa70f299edc94cb4d5eb20a7f0f03a2c4a71f6ac6ede703c"
    sha256 cellar: :any_skip_relocation, big_sur:        "2bb45a15c3910221420ca2d1dd4e48dc1fbefc664f7f27598947dc2b38dd3342"
    sha256 cellar: :any_skip_relocation, catalina:       "97c2ca46cf9fd86957425791125638a96087a69ed2caa8095b3d0f3552ec1265"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fac936844ac832c53bf10ff12b2104e224496c08e632cd11465580ef7f74b456"
  end

  depends_on "python@3.11"

  resource "bashlex" do
    url "https://files.pythonhosted.org/packages/1b/57/8de844f7702f644382def6aee76c64da5a1acfbc22a23ffbc565e0ec69cd/bashlex-0.16.tar.gz"
    sha256 "dc6f017e49ce2d0fe30ad9f5206da9cd13ded073d365688c9fda525354e8c373"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
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
