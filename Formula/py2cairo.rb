class Py2cairo < Formula
  desc "Python 2 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.15.6/pycairo-1.15.6.tar.gz"
  sha256 "ad150ea637860836b66705e0513b8e59494538f0b80497ad3462051368755016"

  bottle do
    cellar :any
    sha256 "0b144ea0217a4323ebdd4c6193f05032a4b9acaa5be1c5ef5228c4b97347142c" => :high_sierra
    sha256 "cfb94dc8dee31783cddfc668b1a15992ec064faba8d7793673b36ebf74ac328f" => :sierra
    sha256 "c8cb8682772e1ad9ee160e6b80b8452b6a07664eb9fd570c7ed174ff62df3326" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "python" if MacOS.version <= :snow_leopard

  def install
    system "python", *Language::Python.setup_install_args(prefix)
  end

  test do
    system "python", "-c", "import cairo; print(cairo.version)"
  end
end
