class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.18.0/pycairo-1.18.0.tar.gz"
  sha256 "abd42a4c9c2069febb4c38fe74bfc4b4a9d3a89fea3bc2e4ba7baff7a20f783f"

  bottle do
    cellar :any
    sha256 "626e465ddfec24053832ef87240e202b5240d1e5d561005cb1269ea53f6e8ac6" => :mojave
    sha256 "cc08de3f170b4a5b2302b6daf50ba091b7c648835a7b61bddd61229e490c626f" => :high_sierra
    sha256 "892e15ed6352fab8afffb5e363428bc928d0db46b46c8af26037777fbe13618c" => :sierra
    sha256 "4064f445c05b569e750e13c6ff92b4419ef97150210406dc44c7f6b814baf514" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "python"

  def install
    system "python3", *Language::Python.setup_install_args(prefix)
  end

  test do
    system "python3", "-c", "import cairo; print(cairo.version)"
  end
end
