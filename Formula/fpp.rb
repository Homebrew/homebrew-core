class Fpp < Formula
  desc "CLI program that accepts piped input and presents files for selection"
  homepage "https://facebook.github.io/PathPicker/"
  url "https://github.com/facebook/PathPicker/archive/refs/tags/0.9.5.tar.gz"
  sha256 "b0142676ed791085d619d9b3d28d28cab989ffc3b260016766841c70c97c2a52"
  license "MIT"
  head "https://github.com/facebook/pathpicker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6efaf75a2e334b6c87e51be515d5bd32ba6ad1aedc8cd64253020772a9be63da"
    sha256 cellar: :any_skip_relocation, big_sur:       "6efaf75a2e334b6c87e51be515d5bd32ba6ad1aedc8cd64253020772a9be63da"
    sha256 cellar: :any_skip_relocation, catalina:      "6efaf75a2e334b6c87e51be515d5bd32ba6ad1aedc8cd64253020772a9be63da"
    sha256 cellar: :any_skip_relocation, mojave:        "6efaf75a2e334b6c87e51be515d5bd32ba6ad1aedc8cd64253020772a9be63da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f51509aa7ff591a83d65bf092b43f19ecb446c6dd08d55f33f52725b4618fe52"
    sha256 cellar: :any_skip_relocation, all:           "6efaf75a2e334b6c87e51be515d5bd32ba6ad1aedc8cd64253020772a9be63da"
  end

  uses_from_macos "python", since: :catalina

  def install
    (buildpath/"src/tests").rmtree
    # we need to copy the bash file and source python files
    libexec.install "fpp", "src"
    # and then symlink the bash file
    bin.install_symlink libexec/"fpp"
    man1.install "debian/usr/share/man/man1/fpp.1"
  end

  test do
    system bin/"fpp", "--help"
  end
end
