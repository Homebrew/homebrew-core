class Py2cairo < Formula
  desc "Python 2 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.15.2/pycairo-1.15.2.tar.gz"
  sha256 "a66f30c457736f682162e7b3a33bc5e8915c0f3b31ef9bdb4edf43c81935c914"

  bottle do
    cellar :any
    sha256 "66d29fc9a931262e2029bb9792aa3357813ae66b81b1fcb9731e9bd104641fef" => :sierra
    sha256 "b707f47cbeca402be10789d52e05fcdeb85b20cb09908b8dd1651143ed783be0" => :el_capitan
    sha256 "4969f9b495c0f37c1c38fe2f2e95f32a5b3eb55eed7dc7de3331ea7bcf2d6c84" => :yosemite
    sha256 "724bde1d66a5c916c95746fc0f23ea4dcbfaddd7123694553557c4a6d51f9729" => :mavericks
    sha256 "784e49b2f15f30af7f4e255eb2263c6e99ae4e0d0ec961412ff033d0954fd298" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on :python if MacOS.version <= :snow_leopard

  def install
    system "python", *Language::Python.setup_install_args(prefix)
  end

  test do
    system "python", "-c", "import cairo; print(cairo.version)"
  end
end
