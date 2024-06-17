class Fpp < Formula
  desc "CLI program that accepts piped input and presents files for selection"
  homepage "https://facebook.github.io/PathPicker/"
  url "https://github.com/facebook/PathPicker/archive/refs/tags/0.9.5.tar.gz"
  sha256 "b0142676ed791085d619d9b3d28d28cab989ffc3b260016766841c70c97c2a52"
  license "MIT"
  head "https://github.com/facebook/pathpicker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dfbe5a6badfc4d4f4d0c21d04b0270457cfcf0d78eed4a93f7c6b8ce18433f93"
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
