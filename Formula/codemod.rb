class Codemod < Formula
  include Language::Python::Virtualenv

  desc "Large-scale codebase refactors assistant tool"
  homepage "https://github.com/facebook/codemod"
  url "https://files.pythonhosted.org/packages/9b/e3/cb31bfcf14f976060ea7b7f34135ebc796cde65eba923f6a0c4b71f15cc2/codemod-1.0.0.tar.gz"
  sha256 "06e8c75f2b45210dd8270e30a6a88ae464b39abd6d0cab58a3d7bfd1c094e588"
  revision 3
  version_scheme 1
  head "https://github.com/facebook/codemod.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e1f2a505f229e358245b5b4acda1521d779a1571fe28906ba6ff41defb16d3f5" => :catalina
    sha256 "fd0d17dff4afb9ed4d7198f3fa8accf98ba34315b00c86e154511ac327eb4598" => :mojave
    sha256 "9a2a53e8930da3bb29f1ba2650ee04583308afc5f3e16a5f7975074da484c099" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
  end

  test do
    # work around some codemod terminal bugs
    ENV["TERM"] = "xterm"
    ENV["LINES"] = "25"
    ENV["COLUMNS"] = "80"
    (testpath/"file1").write <<~EOS
      foo
      bar
      potato
      baz
    EOS
    (testpath/"file2").write <<~EOS
      eeny potato meeny miny moe
    EOS
    system bin/"codemod", "--include-extensionless", "--accept-all", "potato", "pineapple"
    assert_equal %w[foo bar pineapple baz], File.read("file1").lines.map(&:strip)
    assert_equal ["eeny pineapple meeny miny moe"], File.read("file2").lines.map(&:strip)
  end
end
