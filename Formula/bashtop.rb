class Bashtop < Formula
  include Language::Python::Virtualenv

  desc "Bash only* alternative to top, htop, vtop, glances"
  homepage "https://github.com/aristocratos/bashtop"
  url "https://github.com/aristocratos/bashtop/archive/v0.9.16.tar.gz"
  sha256 "836a80864f85dd41fb818f30c2be789931055e45ce1a5842e739e2ec28531367"
  head "https://github.com/aristocratos/bashtop.git", :tag => "v0.9.16"
  # version "0.9.16"

  depends_on "bash"
  depends_on "coreutils"
  depends_on "gnu-sed"
  depends_on "python"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/c4/b8/3512f0e93e0db23a71d82485ba256071ebef99b227351f0f5540f744af41/psutil-5.7.0.tar.gz"
    sha256 "685ec16ca14d079455892f25bd124df26ff9137664af445563c1bd36629b5e0e"
  end

  def install
    # install psutil resource using python3 dependency
    resource("psutil").stage { system "python3", *Language::Python.setup_install_args(libexec/"vendor") }

    # mirror what Makefile for bashtop does
    bin.install "bashtop"
    doc.install "README.md"
  end

  test do
    system "false"
  end
end
