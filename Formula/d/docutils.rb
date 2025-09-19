class Docutils < Formula
  include Language::Python::Virtualenv

  desc "Text processing system for reStructuredText"
  homepage "https://docutils.sourceforge.io"
  url "https://files.pythonhosted.org/packages/e9/86/5b41c32ecedcfdb4c77b28b6cb14234f252075f8cdb254531727a35547dd/docutils-0.22.tar.gz"
  sha256 "ba9d57750e92331ebe7c08a1bbf7a7f8143b86c476acd51528b042216a6aad0f"
  license all_of: [:public_domain, "BSD-2-Clause", "GPL-3.0-or-later", "Python-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, all: "08104af3fe2f9f1db3c115946b03e2b6c25e956aaaea899c5abde08173e1bd21"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
    bin.glob("*.py") do |f|
      bin.install_symlink f => f.basename(".py")
    end

    # Ensure we have an `:all` bottle.
    metadata_file = libexec/Language::Python.site_packages("python3")/"docutils-#{version}.dist-info/METADATA"
    inreplace metadata_file, "/usr/local", HOMEBREW_PREFIX
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
