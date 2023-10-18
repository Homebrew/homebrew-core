class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.25.0/pycairo-1.25.0.tar.gz"
  sha256 "37842b9bfa6339c45a5025f752e1d78d5840b1a0f82303bdd5610846ad8b5c4f"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "45e7b36fd39af69fd0437f365ad2167c07733fe93a38746fe7cf12dcf4b03e34"
    sha256 cellar: :any,                 arm64_ventura:  "379d18ca48abec0a39a67e1cbbbc7a1c488c060158e834de0ea5c32d6015552b"
    sha256 cellar: :any,                 arm64_monterey: "41066077b784537a3c5bed96481d41252352196544d47e4db5dbb0d893db2b4f"
    sha256 cellar: :any,                 sonoma:         "497a84b352b98c6374903c3ee9261c532c041d0a5f59b566dfc3a4a2e6dc669b"
    sha256 cellar: :any,                 ventura:        "9ad85af68d9e2c97f8c03498739f2fdfdd0957111bc339b0ad39ce57f7ad407b"
    sha256 cellar: :any,                 monterey:       "587b1b258b0d67f386308ba4a273a9e988b760160cc6d1bd5ca1ea50cee9973d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2845d3783b3ff799d559e908abc6cf83f229d40ff1c663e43c40ce680f0355a"
  end

  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "cairo"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      system python, "-c", "import cairo; print(cairo.version)"
    end
  end
end
