class Doctopdf < Formula
  include Language::Python::Virtualenv

  desc "Offline batch .doc/.docx to PDF converter using Microsoft Word on macOS"
  homepage "https://github.com/HarryW00/doctopdf"
  url "https://files.pythonhosted.org/packages/ad/60/8b749ff80844cd3de95d1b005e1a41c0d63f0745724f338a78e2f9c9e286/doctopdf-2.0.5b0.tar.gz"
  sha256 "d90a5278230267c3fa2bfc4c691742838de1325030973d991a97499690797864"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a540cfc95fcc0aedba2302ced7907e54e5208bb0d3391fe1302154a9f6cb2ef8"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/convert-word-pdf --version")
  end
end
