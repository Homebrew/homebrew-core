class Docutils < Formula
  include Language::Python::Virtualenv

  desc "Text processing system for reStructuredText"
  homepage "https://docutils.sourceforge.io"
  url "https://files.pythonhosted.org/packages/ae/ed/aefcc8cd0ba62a0560c3c18c33925362d46c6075480bfa4df87b28e169a9/docutils-0.21.2.tar.gz"
  sha256 "3a6b18732edf182daa3cd12775bbb338cf5691468f91eeeb109deff6ebfa986f"
  license all_of: [:public_domain, "BSD-2-Clause", "GPL-3.0-or-later", "Python-2.0"]
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "902ea89749b8809d45604630f6246d07294e95af725a23d856d5b7006a1efb96"
  end

  depends_on "python@3.13"

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
