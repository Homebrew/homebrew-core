class Docutils < Formula
  include Language::Python::Virtualenv

  desc "Text processing system for reStructuredText"
  homepage "https://docutils.sourceforge.io"
  url "https://files.pythonhosted.org/packages/21/ff/c495b797462434f0befcb598b51cde31c3ebdf8577c3fd9d9a8f5eeb844c/docutils-0.21.1.tar.gz"
  sha256 "65249d8a5345bc95e0f40f280ba63c98eb24de35c6c8f5b662e3e8948adea83f"
  license all_of: [:public_domain, "BSD-2-Clause", "GPL-3.0-or-later", "Python-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "360b41e05f33a9b479243cd1cfe56d620a2804a716db7758fdc5ad588804e8dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "360b41e05f33a9b479243cd1cfe56d620a2804a716db7758fdc5ad588804e8dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "360b41e05f33a9b479243cd1cfe56d620a2804a716db7758fdc5ad588804e8dd"
    sha256 cellar: :any_skip_relocation, sonoma:         "360b41e05f33a9b479243cd1cfe56d620a2804a716db7758fdc5ad588804e8dd"
    sha256 cellar: :any_skip_relocation, ventura:        "360b41e05f33a9b479243cd1cfe56d620a2804a716db7758fdc5ad588804e8dd"
    sha256 cellar: :any_skip_relocation, monterey:       "360b41e05f33a9b479243cd1cfe56d620a2804a716db7758fdc5ad588804e8dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b17c61fe4ef6d2e36eff52b7ba600b6d9c757681d438fdfc4dcfe4b551dc9ada"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
    bin.glob("*.py") do |f|
      bin.install_symlink f => f.basename(".py")
    end
  end

  test do
    (testpath/"README.txt").write <<~EOS
      .. include:: docs/header0.txt

      =========================
      README: Docutils
      =========================

      :Author: David Goodger
      :Contact: goodger@python.org
      :Date: $Date: 2023-05-09 20:32:19 +0200 (Di, 09. Mai 2023) $
      :Web site: https://docutils.sourceforge.io/
      :Copyright: This document has been placed in the public domain.

      .. contents::
    EOS

    mkdir_p testpath/"docs"
    touch testpath/"docs"/"header0.txt"
    system bin/"rst2man", testpath/"README.txt"
  end
end
