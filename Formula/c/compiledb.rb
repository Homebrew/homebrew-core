class Compiledb < Formula
  include Language::Python::Virtualenv

  desc "Generate a Clang compilation database for Make-based build systems"
  homepage "https://github.com/nickdiego/compiledb"
  url "https://files.pythonhosted.org/packages/76/62/30fb04404b1d4a454f414f792553d142e8acc5da27fddcce911fff0fe570/compiledb-0.10.1.tar.gz"
  sha256 "06bb47dd1fa04de3a12720379ff382d40441074476db7c16a27e2ad79b7e966e"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e634ab1ba68aa04587cb327aaf5ca6875ca82b821d4b5a6dbd1054836eab33e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a22ef72db1ebbbee1c4349c5c9052b3f51080319118c3c9870ddd610d30e8e54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1bff69f65134554069046e579e38a23b2b0af952c06d6fdcef2c2c8a4dd36446"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ad98a3a62dd5dad7d1073909414834446c0bd22acab0604491ff44bbfb2cfaa"
    sha256 cellar: :any_skip_relocation, ventura:        "b3ad99071217c3ce467fb302c1bbbeee76bfbff3d486297965d99bbe9a1e09cb"
    sha256 cellar: :any_skip_relocation, monterey:       "273c62ba00d1dcce5160e874b898d41a60dca02aeb482d31c60c26763809106d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65f016f20d145ded077358884691f6138684ad25b7f51195cb0650c75c27afc2"
  end

  depends_on "python@3.12"

  resource "bashlex" do
    url "https://files.pythonhosted.org/packages/76/60/aae0bb54f9af5e0128ba90eb83d8d0d506ee8f0475c4fdda3deeda20b1d2/bashlex-0.18.tar.gz"
    sha256 "5bb03a01c6d5676338c36fd1028009c8ad07e7d61d8a1ce3f513b7fff52796ee"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
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
