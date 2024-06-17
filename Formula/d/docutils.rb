class Docutils < Formula
  include Language::Python::Virtualenv

  desc "Text processing system for reStructuredText"
  homepage "https://docutils.sourceforge.io"
  url "https://files.pythonhosted.org/packages/ae/ed/aefcc8cd0ba62a0560c3c18c33925362d46c6075480bfa4df87b28e169a9/docutils-0.21.2.tar.gz"
  sha256 "3a6b18732edf182daa3cd12775bbb338cf5691468f91eeeb109deff6ebfa986f"
  license all_of: [:public_domain, "BSD-2-Clause", "GPL-3.0-or-later", "Python-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1be754c074ea2ae9b0d8ed3d21b8b6265064c260a49dbcf6dcb3adc967d4d287"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1be754c074ea2ae9b0d8ed3d21b8b6265064c260a49dbcf6dcb3adc967d4d287"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1be754c074ea2ae9b0d8ed3d21b8b6265064c260a49dbcf6dcb3adc967d4d287"
    sha256 cellar: :any_skip_relocation, sonoma:         "1be754c074ea2ae9b0d8ed3d21b8b6265064c260a49dbcf6dcb3adc967d4d287"
    sha256 cellar: :any_skip_relocation, ventura:        "1be754c074ea2ae9b0d8ed3d21b8b6265064c260a49dbcf6dcb3adc967d4d287"
    sha256 cellar: :any_skip_relocation, monterey:       "1be754c074ea2ae9b0d8ed3d21b8b6265064c260a49dbcf6dcb3adc967d4d287"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da5189fbc044da3ad89386c3a23411f4a24bbcfa0881bb2bb106e387ed95f3a3"
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
