class Graphviz2drawio < Formula
  include Language::Python::Virtualenv

  desc "Convert graphviz (dot) files into draw.io / lucid (mxGraph) format"
  homepage "https://github.com/hbmartin/graphviz2drawio/"
  url "https://files.pythonhosted.org/packages/7e/ab/9db7e2d8172eba962fd9978a481933bab6c592868def468aa7c045ad05a2/graphviz2drawio-0.5.0.tar.gz"
  sha256 "0bc8c1fec4b8e22e96f6991f44eba95250242aa9c748057d6f5d114bd90f3809"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7b427939751ed185abbd830b55e4d8ca5970ef464f562c0b24c0a18d6f33a51c"
    sha256 cellar: :any,                 arm64_ventura:  "82db0e8378929fe4177f7895fa3f6c3db0319feea96015102857513979c9d8f5"
    sha256 cellar: :any,                 arm64_monterey: "d70bbdf4ad012ac79e501e3d86ec1de65b65f511ea34e677eed6ec1313d395a7"
    sha256 cellar: :any,                 sonoma:         "5fdf13822d27b650434bb63fdd6381c903380f98bc29f7c50ae6ce86a584d84a"
    sha256 cellar: :any,                 ventura:        "9ed03a41a1dfa5e89a51e14b8b156c9bc499a1ea7697660e22ba589322683c64"
    sha256 cellar: :any,                 monterey:       "196a599faf228008d2bb652f1c1a7ecb5533b0fee8574938858d2dc3cdb1ca24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bb6c647854bd92fd180328021e8534da1c0e555a35f555c4da3c018e45519c9"
  end

  depends_on "graphviz"
  depends_on "python@3.12"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/d5/ce/dc3a664654f1abed89d4e8a95ac3af02a2a0449c776ccea5ef9f48bde267/puremagic-1.27.tar.gz"
    sha256 "7cb316f40912f56f34149f8ebdd77a91d099212d2ed936feb2feacfc7cbce2c1"
  end

  resource "pygraphviz" do
    url "https://files.pythonhosted.org/packages/8c/41/7b9a22df38bb7884012b34f2986d765691dbe41bf5e7af881dfd09f8145f/pygraphviz-1.13.tar.gz"
    sha256 "6ad8aa2f26768830a5a1cfc8a14f022d13df170a8f6fdfd68fd1aa1267000964"
  end

  resource "svg-path" do
    url "https://files.pythonhosted.org/packages/33/a0/4983cdedf62c3a1dd42b698813312fc51dd159983333fce9ec4189cd83a9/svg.path-6.3.tar.gz"
    sha256 "e937740a316a7fec86acd217ab6226e112f51328078524126bb7ea9dbe7b1ade"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "mxCell id=\"node1\"", pipe_output(bin/"graphviz2drawio", "digraph { a -> b }")

    assert_match version.to_s, shell_output("#{bin}/graphviz2drawio --version")
  end
end
