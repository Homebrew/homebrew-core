class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.20.1/pycairo-1.20.1.tar.gz"
  sha256 "1ee72b035b21a475e1ed648e26541b04e5d7e753d75ca79de8c583b25785531b"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]

  bottle do
    sha256 cellar: :any, arm64_big_sur: "7ae376cf57b7dbe9725a196c440739c6b26d53c73ceedc181914f34a862b976c"
    sha256 cellar: :any, big_sur:       "049d508d2797fd41cc9a0cf8cf8319bb667716ea378d5f60a98972e0ef2c6f05"
    sha256 cellar: :any, catalina:      "00bfdfca9a8665250cfc9d4f8c8eb96c0b4fd89676be20ed93b7846878c1b129"
    sha256 cellar: :any, mojave:        "f36dfa15e2516165595fb12892f8ed3490cb1be28c5e51212746c54de7ac0223"
    sha256 cellar: :any, high_sierra:   "0b82f9de10293fd7eb028ccb5d61dff9dd6b934376c9badde21a516b8fabcc24"
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
