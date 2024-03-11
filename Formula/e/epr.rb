class Epr < Formula
  include Language::Python::Virtualenv

  desc "Command-line EPUB reader"
  homepage "https://github.com/wustho/epr"
  url "https://files.pythonhosted.org/packages/39/20/d647083aa86ec9da89b4f04b62dd6942aabb77528fd2efe018ff1cd145d2/epr-reader-2.4.15.tar.gz"
  sha256 "a5cd0fbab946c9a949a18d0cb48a5255b47e8efd08ddb804921aaaf0caa781cc"
  license "MIT"
  head "https://github.com/wustho/epr.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "20655597e36e78c61cbf8529193c9391f1d4c5d8dc7fa789221536d023ce0046"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be2803f21fcc1688d985c2ec77305359b784e99e8fffb01329bab2cc53ec1e51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d607d7fdf6ebd3fd0ab45f1f16e2f3fc0de275e03bf58d510143e137234b8227"
    sha256 cellar: :any_skip_relocation, sonoma:         "88d30f8a149c30537ccb114c9090754f4fa4acb7e71eddeb46e2de2a791d0acf"
    sha256 cellar: :any_skip_relocation, ventura:        "56709b668954d21e82bd99e8cf813d1b76413474284e0cf9049ae7076d5d444a"
    sha256 cellar: :any_skip_relocation, monterey:       "73f30cee5ee6fe7e8a86646e23ae9936137929bec1133a626e7d057093b1d37e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b61b874f5d15fe349fec834ec676423a900e57c1f1a26906cdab92040edc6034"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Reading history:", shell_output("#{bin}/epr -r")
  end
end
