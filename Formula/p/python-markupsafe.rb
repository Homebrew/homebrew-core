class PythonMarkupsafe < Formula
  desc "Implements a XML/HTML/XHTML Markup safe string for Python"
  homepage "https://palletsprojects.com/p/markupsafe/"
  url "https://files.pythonhosted.org/packages/6d/7c/59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbf/MarkupSafe-2.1.3.tar.gz"
  sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
  license "BSD-3-Clause"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a0c3e38a2a14bce81bbfaf117499341d23b1813149ba1de77272d798556365f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e5c53893049bce152240be64418f852ca529770847865f77b1fb582b605ceaf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "467a14762ebe213e7f5b273ea3ee33bbbfb37e90ee301b6e100cec0081149e76"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8cf12192c1315632fabf1d89cb127c135ca1fd8eb0aa917d2622a759585ad8d"
    sha256 cellar: :any_skip_relocation, ventura:        "05442b539494886d34a22bf12a9689233c8171174d62763751a0771c2ad104c3"
    sha256 cellar: :any_skip_relocation, monterey:       "ac87c7419b64e46c97095bed03df4c0bb1946253abbb4268c766e63be82fa1e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e7d0de888dd24db251b12331b419aeece84b54fb7749a3a2d7013cd086610f1"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

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
      system python_exe, "-c", "from markupsafe import escape"
    end
  end
end
