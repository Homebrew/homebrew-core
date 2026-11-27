class Fpp < Formula
  desc "CLI program that accepts piped input and presents files for selection"
  homepage "https://meta.github.io/PathPicker/"
  url "https://github.com/meta/PathPicker/archive/refs/tags/0.9.5.tar.gz"
  sha256 "b0142676ed791085d619d9b3d28d28cab989ffc3b260016766841c70c97c2a52"
  license "MIT"
  head "https://github.com/meta/pathpicker.git", branch: "main"

  bottle do
    rebuild 1
    manifest_sha256 "1d148b1e23d28b824d1c45fa61829e9d2f916e64760dd6584f91ff7f6dfe4773"
    sha256 cellar: :any_skip_relocation, all: "3cd7e3e25d729646c8cbb993eaa2c3d517dc128693dcdbc39bd1362c11429390"
  end

  uses_from_macos "python"

  def install
    rm_r(buildpath/"src/tests")
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
