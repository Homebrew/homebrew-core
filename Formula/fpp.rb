class Fpp < Formula
  desc "CLI program that accepts piped input and presents files for selection"
  homepage "https://facebook.github.io/PathPicker/"
  url "https://github.com/facebook/PathPicker/releases/download/0.9.2/fpp.0.9.2.tar.gz"
  sha256 "f2b233b1e18bdafb1cd1728305e926aabe217406e65091f1e58589e6157e1952"
  license "MIT"
  revision 3
  head "https://github.com/facebook/pathpicker.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6efaf75a2e334b6c87e51be515d5bd32ba6ad1aedc8cd64253020772a9be63da"
    sha256 cellar: :any_skip_relocation, big_sur:       "6efaf75a2e334b6c87e51be515d5bd32ba6ad1aedc8cd64253020772a9be63da"
    sha256 cellar: :any_skip_relocation, catalina:      "6efaf75a2e334b6c87e51be515d5bd32ba6ad1aedc8cd64253020772a9be63da"
    sha256 cellar: :any_skip_relocation, mojave:        "6efaf75a2e334b6c87e51be515d5bd32ba6ad1aedc8cd64253020772a9be63da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f51509aa7ff591a83d65bf092b43f19ecb446c6dd08d55f33f52725b4618fe52"
    sha256 cellar: :any_skip_relocation, all:           "6efaf75a2e334b6c87e51be515d5bd32ba6ad1aedc8cd64253020772a9be63da"
  end

  depends_on "python@3.10"

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
