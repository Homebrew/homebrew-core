class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.21.0/pycairo-1.21.0.tar.gz"
  sha256 "251907f18a552df938aa3386657ff4b5a4937dde70e11aa042bc297957f4b74b"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8e3a08d98747e940a973e78b4ed55c4a1111ab87e7e7bf342951cb4b9bc86886"
    sha256 cellar: :any,                 arm64_big_sur:  "e4ae24c8dda0f86ac318702306e51838ed3bdeb9f75ac4934683dd33d849e38f"
    sha256 cellar: :any,                 monterey:       "0c6cd6baa4cc9d42d050006af7a730c31c8ce1b8467c8f9a71235290f0173280"
    sha256 cellar: :any,                 big_sur:        "a9ef02e15a1c709248dc9dd3521f83927e34101bde0efb02d31647648570e033"
    sha256 cellar: :any,                 catalina:       "1f493adc9999e0f08d65790a7a92157caa52d77a1334ed3ea5b9366d347d2559"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab3fee24d9db4323c74d0d1244b2c66f59c36f2f3fd8b1bbe02a8f4156babe7c"
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
