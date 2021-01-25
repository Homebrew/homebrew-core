class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.20.0/pycairo-1.20.0.tar.gz"
  sha256 "5695a10cb7f9ae0d01f665b56602a845b0a8cb17e2123bfece10c2e58552468c"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]
  revision 1

  bottle do
    cellar :any
    sha256 "049d508d2797fd41cc9a0cf8cf8319bb667716ea378d5f60a98972e0ef2c6f05" => :big_sur
    sha256 "7ae376cf57b7dbe9725a196c440739c6b26d53c73ceedc181914f34a862b976c" => :arm64_big_sur
    sha256 "00bfdfca9a8665250cfc9d4f8c8eb96c0b4fd89676be20ed93b7846878c1b129" => :catalina
    sha256 "f36dfa15e2516165595fb12892f8ed3490cb1be28c5e51212746c54de7ac0223" => :mojave
    sha256 "0b82f9de10293fd7eb028ccb5d61dff9dd6b934376c9badde21a516b8fabcc24" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "python@3.9"

  def install
    system Formula["python@3.9"].bin/"python3", *Language::Python.setup_install_args(prefix)
  end

  test do
    system Formula["python@3.9"].bin/"python3", "-c", "import cairo; print(cairo.version)"
  end
end
