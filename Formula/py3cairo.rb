class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.18.0/pycairo-1.18.0.tar.gz"
  sha256 "abd42a4c9c2069febb4c38fe74bfc4b4a9d3a89fea3bc2e4ba7baff7a20f783f"

  bottle do
    cellar :any
    sha256 "f4f21f7bfd11b21b5885cd8fd514897f906fc003c224098c6ab0b01e9ac0a6ce" => :mojave
    sha256 "4c8d11b53dcad73b398d63967734f251bba7794143b69e11505b2c5f912ca031" => :high_sierra
    sha256 "8f36a76c0ced8e4203e2198ddcb7f32e2f254221d8f8a6c07909a50f5bcf29ac" => :sierra
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
