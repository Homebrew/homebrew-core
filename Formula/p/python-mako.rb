class PythonMako < Formula
  desc "Fast templating language for Python"
  homepage "https://www.makotemplates.org/"
  url "https://files.pythonhosted.org/packages/d4/1b/71434d9fa9be1ac1bc6fb5f54b9d41233be2969f16be759766208f49f072/Mako-1.3.2.tar.gz"
  sha256 "2a0c8ad7f6274271b3bb7467dd37cf9cc6dab4bc19cb69a4ef10669402de698e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69b144051df06b792d1c01ebf8eb347d667402177bd03ec0cf63f8702865d713"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b78616165ab17b3907e276dd3f64ef8ce683f22314a4dd24550cff9521c61f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70488d10d30cb4ed9c1b988330fba13a2763386567e8da414c90cbdf467fb8a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "2163323bbcd74b38325cb0d65ac9845d5e9bae9a3fbae90499d34a09143e4a00"
    sha256 cellar: :any_skip_relocation, ventura:        "182c85d9fccf746935b085af2f03c80324d93dd2ee68431accca8bdfa76bce29"
    sha256 cellar: :any_skip_relocation, monterey:       "52eb3f1e308a73ea8b63ac5f2ff14d84806079f812d55b80f17a66f973c39c22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eae21ee2930e9b555f3d40b97f540b70e2d7b8f94e752112c749828895415c72"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python-markupsafe"

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  def caveats
    <<~EOS
      To run `mako-render`, you may need to `brew install #{pythons.last}`
    EOS
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "from mako.template import Template"
    end

    (testpath/"test.mako").write <<~EOS
      Hello, ${name}!
    EOS
    output = shell_output("#{bin}/mako-render --var name=Homebrew test.mako")
    assert_equal "Hello, Homebrew!\n", output
  end
end
