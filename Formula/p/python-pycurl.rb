class PythonPycurl < Formula
  desc "Python Interface To libcurl"
  homepage "http://pycurl.io/"
  url "https://files.pythonhosted.org/packages/c9/5a/e68b8abbc1102113b7839e708ba04ef4c4b8b8a6da392832bb166d09ea72/pycurl-7.45.3.tar.gz"
  sha256 "8c2471af9079ad798e1645ec0b0d3d4223db687379d17dd36a70637449f81d6b"
  license any_of: ["LGPL-2.1-or-later", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "71ccf2bb733435739ab3b34ee708ad08c2cfb67fd873e3c0a0d8e3fe66c4e63b"
    sha256 cellar: :any,                 arm64_ventura:  "79223f7862d985e145f47dc169d1eea0dd1192b7d856879fab9507e961ec80fb"
    sha256 cellar: :any,                 arm64_monterey: "af88878f404cd4945b86acd54e48978eec498d7f2068ae6c7eb02184425d478c"
    sha256 cellar: :any,                 sonoma:         "581bb81a65f50478885acbe259d378b64d5854009155363942a3809ea6efe31f"
    sha256 cellar: :any,                 ventura:        "cd7d71242cdbb86ff6bf9dc48c05f466f9c8342f31690f800ced655b421b2229"
    sha256 cellar: :any,                 monterey:       "0cfb4ca826115c8a4157a028cd21cc1a2d0f7ed81959286975eaee9ddb03165e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc893fcef966ba5f2321f65dc65df7ec093193685b753bbb6dd8e7f7907b6abe"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "curl"
  depends_on "openldap"
  depends_on "openssl@3"

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
      system python_exe, "-c", "import pycurl"
    end
  end
end
