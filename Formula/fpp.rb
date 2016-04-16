class Fpp < Formula
  desc "CLI program that accepts piped input and presents files for selection"
  homepage "https://facebook.github.io/PathPicker/"
  url "https://github.com/facebook/PathPicker/releases/download/0.7.1/fpp.0.7.1.tar.gz"
  sha256 "442932c05df6bddae8b24c48eb9a24d8892daf83d88ed3978d5cd835d3cf33a7"
  head "https://github.com/facebook/pathpicker.git"

  bottle :unneeded

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    # we need to copy the bash file and source python files
    libexec.install Dir["*"]
    # and then symlink the bash file
    bin.install_symlink libexec/"fpp"
  end

  test do
    system bin/"fpp", "--help"
  end
end
