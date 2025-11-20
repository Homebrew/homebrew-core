class Epr < Formula
  include Language::Python::Virtualenv

  desc "Command-line EPUB reader"
  homepage "https://github.com/wustho/epr"
  url "https://files.pythonhosted.org/packages/39/20/d647083aa86ec9da89b4f04b62dd6942aabb77528fd2efe018ff1cd145d2/epr-reader-2.4.15.tar.gz"
  sha256 "a5cd0fbab946c9a949a18d0cb48a5255b47e8efd08ddb804921aaaf0caa781cc"
  license "MIT"
  head "https://github.com/wustho/epr.git", branch: "master"

  bottle do
    rebuild 7
    sha256 cellar: :any_skip_relocation, all: "571401b416ae87c8443cf20db13c2150c564f0a234eacaf903660c2d2dbde706"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Reading history:", shell_output("#{bin}/epr -r")
  end
end
