class Jello < Formula
  include Language::Python::Virtualenv

  desc "Filter JSON and JSON Lines data with Python syntax"
  homepage "https://github.com/kellyjonbrazil/jello"
  url "https://files.pythonhosted.org/packages/8a/1d/25e13e337f0c5c8076a4fc42db02b726529b611a69d816b71f8d591cf0f5/jello-1.6.0.tar.gz"
  sha256 "f0a369b2bd0c1db6cb07abbfd014034c22158c160e3df2a9d55b258bc6fbfa42"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1217174cb1d558540f2b90eef4ce0c329684032514ad18c165287db1da0b7a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1217174cb1d558540f2b90eef4ce0c329684032514ad18c165287db1da0b7a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1217174cb1d558540f2b90eef4ce0c329684032514ad18c165287db1da0b7a2"
    sha256 cellar: :any_skip_relocation, ventura:        "ab0954cb09156c2c55502e596220e2fdfe887dde5ccbda8c20db768d68d2d4dd"
    sha256 cellar: :any_skip_relocation, monterey:       "ab0954cb09156c2c55502e596220e2fdfe887dde5ccbda8c20db768d68d2d4dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab0954cb09156c2c55502e596220e2fdfe887dde5ccbda8c20db768d68d2d4dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d4021cdccb1bc2a63a5d879d04a1290e11a2ca1e30a5f7f6d04a5a951d46c52"
  end

  depends_on "pygments"
  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
    man1.install "man/jello.1"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/jello _.foo", "{\"foo\":1}")
  end
end
