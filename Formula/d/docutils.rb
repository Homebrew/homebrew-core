class Docutils < Formula
  include Language::Python::Virtualenv

  desc "Text processing system for reStructuredText"
  homepage "https://docutils.sourceforge.io"
  url "https://files.pythonhosted.org/packages/d9/02/111134bfeb6e6c7ac4c74594e39a59f6c0195dc4846afbeac3cba60f1927/docutils-0.22.3.tar.gz"
  sha256 "21486ae730e4ca9f622677b1412b879af1791efcfba517e4c6f60be543fc8cdd"
  license all_of: [:public_domain, "BSD-2-Clause", "GPL-3.0-or-later", "Python-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, all: "869e85ddf635def088e1e93d9a335a94b69f0a946bcb38cf27a15aaf4f0c5243"
  end

  depends_on "python@3.14"

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
    touch testpath/"docs/header0.txt"
    system bin/"rst2man", testpath/"README.txt"
  end
end
