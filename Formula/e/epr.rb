class Epr < Formula
  include Language::Python::Virtualenv

  desc "Command-line EPUB reader"
  homepage "https://github.com/wustho/epr"
  url "https://files.pythonhosted.org/packages/39/20/d647083aa86ec9da89b4f04b62dd6942aabb77528fd2efe018ff1cd145d2/epr-reader-2.4.15.tar.gz"
  sha256 "a5cd0fbab946c9a949a18d0cb48a5255b47e8efd08ddb804921aaaf0caa781cc"
  license "MIT"
  head "https://github.com/wustho/epr.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e68b998122d66d7f2fabc5c5b78a0d635d452861b2399ae70f48d6bb1eecc999"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8a76e60cf2662821d5e91658db9f7b260f2df312dc81f07f96789b5bde15123"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f390d3909cd2dd19b8bb615676454c051496d08a733f3d0bb45add113f2fbceb"
    sha256 cellar: :any_skip_relocation, sonoma:         "2aba44b4ec5ff5514e08ed81bee85566bfadc78615d9af0627b43004364f26c5"
    sha256 cellar: :any_skip_relocation, ventura:        "f3f4df93d10602d40ecf6e6d460c5e6836eb34ddb41b5e67cbe8c04578d5adc6"
    sha256 cellar: :any_skip_relocation, monterey:       "739e995754f012ee4091e136719d2fe6de9495d006214a2b0342c1d91a4b8f90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "637fd130f94aaf3e7f40a36eadc3918ff346b47a601862ce5ef1e05ceae90324"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Reading history:", shell_output("#{bin}/epr -r")
  end
end
