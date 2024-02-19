class PythonBotocore < Formula
  desc "Low-level, data-driven core of boto 3"
  homepage "https://botocore.amazonaws.com/v1/documentation/api/latest/index.html"
  url "https://files.pythonhosted.org/packages/bc/d8/a31a6f55f2e438e6e3f19fc302a540ecf2c545684be5b7f5b875aca54892/botocore-1.34.19.tar.gz"
  sha256 "64352b2f05de5c6ab025c1d5232880c22775356dcc5a53d798a6f65db847e826"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f37cf7c1ff399e990a3206f0e1c36bd276bf23d333871f534320bbf7e13f8d33"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d61448214669177794e54d0e57daa5d3d0907d8c42a35852bd45fcf38806800"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18792c992aff3d0ad16bd3c2accfe5e79b19dcf14af71f1f035f12304ca49bfb"
    sha256 cellar: :any_skip_relocation, sonoma:         "1fc51ddf4d6fe1d678866fe9fd3f8704a8c14bb4182d6a786cec4faf15aae2f1"
    sha256 cellar: :any_skip_relocation, ventura:        "261f03107db4010a79aadaa37c71e852a7366a73e1279d6adcb73f609ceb541a"
    sha256 cellar: :any_skip_relocation, monterey:       "e80cae228e30953c8f1d958892f6e308a621d0a0da6419968cc0869442072f53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f39f4d9da49cf1a05a519d10fa9fe3f4bec8b67fc631b782a8f6b8673816ae1"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python-dateutil"
  depends_on "python-jmespath"
  depends_on "python-urllib3"
  depends_on "six"

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
      system python_exe, "-c", "from botocore.config import Config"
    end
  end
end
