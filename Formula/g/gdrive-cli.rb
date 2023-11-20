class GdriveCli < Formula
  desc "Google Drive CLI Client"
  homepage "https://github.com/glotlabs/gdrive"
  url "https://github.com/glotlabs/gdrive/releases/download/3.9.0/gdrive_macos-x64.tar.gz"
  sha256 "348f57f42785e3eedfb933bcf079deba8cf51ac2cf699d29539f33956d025d57"
  license "MIT"
  head "https://github.com/glotlabs/gdrive.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "aedaf65cf84ca164aa46149a14df2cab9a3ff9d7679fea4621442170839f3e0b"
  end

  conflicts_with "gdrive", because: "gdrive also ships a gdrive binary"

  def install
    bin.install "gdrive"
  end

  test do
    assert_match "gdrive 3.9.0", shell_output("#{bin}/gdrive version")
  end
end
