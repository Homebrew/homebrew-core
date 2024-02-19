class PythonLxml < Formula
  desc "Pythonic binding for the libxml2 and libxslt libraries"
  homepage "https://github.com/lxml/lxml"
  url "https://files.pythonhosted.org/packages/2b/b4/bbccb250adbee490553b6a52712c46c20ea1ba533a643f1424b27ffc6845/lxml-5.1.0.tar.gz"
  sha256 "3eea6ed6e6c918e468e693c41ef07f3c3acc310b70ddd9cc72d9ef84bc9564ca"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "447e87be72933607cf593e5aea08d068eddebdd0d792933521ddc2fa80ac97c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b3eb68b9df4a047205d38c0bd0952554a8924237a35752f8b5aab044d377a07"
    sha256 cellar: :any,                 arm64_monterey: "055c1a45b71101ef1ce2a1672d8fdf6368b413e092ca057e9a6890577e3d31e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "c62f871719fbf39547401c6ea6857afb3160aa23d31c2633445fc6dcc411ee47"
    sha256 cellar: :any_skip_relocation, ventura:        "6c28366685e1dd6834730fa43c6ee1239e726c5a3a03a4d349b8ca11306a50c8"
    sha256 cellar: :any,                 monterey:       "332bda2757cc293bca09c67e244c1e2f5f6f2010db8e09077bd435dfd40c98e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8396aea90abea66b593cb94e7ba0b54e1a1c91e2cba9f1a0e3a709bf5df9899"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import lxml"
    end
  end
end
