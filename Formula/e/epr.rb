class Epr < Formula
  include Language::Python::Virtualenv

  desc "Command-line EPUB reader"
  homepage "https://github.com/wustho/epr"
  url "https://files.pythonhosted.org/packages/39/20/d647083aa86ec9da89b4f04b62dd6942aabb77528fd2efe018ff1cd145d2/epr-reader-2.4.15.tar.gz"
  sha256 "a5cd0fbab946c9a949a18d0cb48a5255b47e8efd08ddb804921aaaf0caa781cc"
  license "MIT"
  head "https://github.com/wustho/epr.git", branch: "master"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "17bf56c5d9c14a0bf540e7a9227150af4dfbe54ee1e067d31fec6e47d9b4ac4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17bf56c5d9c14a0bf540e7a9227150af4dfbe54ee1e067d31fec6e47d9b4ac4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17bf56c5d9c14a0bf540e7a9227150af4dfbe54ee1e067d31fec6e47d9b4ac4a"
    sha256 cellar: :any_skip_relocation, sonoma:         "17bf56c5d9c14a0bf540e7a9227150af4dfbe54ee1e067d31fec6e47d9b4ac4a"
    sha256 cellar: :any_skip_relocation, ventura:        "17bf56c5d9c14a0bf540e7a9227150af4dfbe54ee1e067d31fec6e47d9b4ac4a"
    sha256 cellar: :any_skip_relocation, monterey:       "17bf56c5d9c14a0bf540e7a9227150af4dfbe54ee1e067d31fec6e47d9b4ac4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d28c29932295a86b7efcd95e2773063e936600fecf74e99670c7345004ed18c6"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Reading history:", shell_output("#{bin}/epr -r")
  end
end
