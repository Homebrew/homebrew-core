class Epr < Formula
  include Language::Python::Virtualenv

  desc "Command-line EPUB reader"
  homepage "https://github.com/wustho/epr"
  url "https://files.pythonhosted.org/packages/39/20/d647083aa86ec9da89b4f04b62dd6942aabb77528fd2efe018ff1cd145d2/epr-reader-2.4.15.tar.gz"
  sha256 "a5cd0fbab946c9a949a18d0cb48a5255b47e8efd08ddb804921aaaf0caa781cc"
  license "MIT"
  head "https://github.com/wustho/epr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d98c74561ea423741be4268845a86035d5ece2730e8f070330d79eeff5c66b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6d908ffbaf2d86e5138e8eb54cef8ec3d002f53d3fa39df700031dba83f34df"
    sha256 cellar: :any_skip_relocation, monterey:       "230ae4c3ae853bb2a5e389ffc3a086a19da828b94b0f08cc35d7716419865e7e"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2c5e041abeae7147bffac8a6c361583e7c990ba64695fd1d976799b47c09153"
    sha256 cellar: :any_skip_relocation, catalina:       "8c2ae4638d6814fdfdd9444bce8991a85d515a265f4bc1c988e770a4cf4d4b8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f303eb1374e664808e445a7aca7b81589240beb4205a7fd1a05cfaa6fb4f565"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Reading history:", shell_output("#{bin}/epr -r")
  end
end
