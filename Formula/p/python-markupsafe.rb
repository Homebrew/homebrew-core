class PythonMarkupsafe < Formula
  desc "Implements a XML/HTML/XHTML Markup safe string for Python"
  homepage "https://palletsprojects.com/p/markupsafe/"
  url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
  sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0cc38a7440a635c40ccf36cf389d67f496d60f29629cc8eb1e4878f3b318ee60"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ffbb4c9faab696c98e1fe915334453eddfe47e9a7436dc59bdfd80726eb32523"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b0751f5452723def54d6462068289a4ea0aa66870faec5371e7d9d5001e8e9b"
    sha256 cellar: :any_skip_relocation, sonoma:         "4104ef590e9c8a903d826eb3e988ea5c6eae6085f68104f600431a08c6c2b752"
    sha256 cellar: :any_skip_relocation, ventura:        "3dd6f543d51d931d436166c12381a5e93216d9b289a6b8d7d02057abeaafebc3"
    sha256 cellar: :any_skip_relocation, monterey:       "1fb21768ac90b9fd8ca12fb4dc41ebcb5fb5fee1f2f44bdabf0c71d078bf730b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87dd38ca3981cf1336931ba3e1ace8fb0d775675629ae84d4d44f3f2b38f95c3"
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
