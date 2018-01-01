class Fpp < Formula
  desc "CLI program that accepts piped input and presents files for selection"
  homepage "https://facebook.github.io/PathPicker/"
  url "https://github.com/facebook/PathPicker/releases/download/0.7.2/fpp.0.7.2.tar.gz"
  sha256 "bf49a971a3af710aafcd0adf1084df556dd94476d71bbe39eb058f5970ec4378"
  head "https://github.com/facebook/pathpicker.git"

  bottle :unneeded

  depends_on "python" if MacOS.version <= :snow_leopard

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
