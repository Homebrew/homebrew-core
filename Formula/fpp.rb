class Fpp < Formula
  desc "CLI program that accepts piped input and presents files for selection"
  homepage "https://facebook.github.io/PathPicker/"
  url "https://github.com/facebook/PathPicker/releases/download/0.9.2/fpp.0.9.2.tar.gz"
  sha256 "f2b233b1e18bdafb1cd1728305e926aabe217406e65091f1e58589e6157e1952"
  head "https://github.com/facebook/pathpicker.git"

  bottle :unneeded

  depends_on "python"

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
