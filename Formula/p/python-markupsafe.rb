class PythonMarkupsafe < Formula
  desc "Implements a XML/HTML/XHTML Markup safe string for Python"
  homepage "https://palletsprojects.com/p/markupsafe/"
  url "https://files.pythonhosted.org/packages/6d/7c/59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbf/MarkupSafe-2.1.3.tar.gz"
  sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ed07d27ec38c0368c5f5ce625d5a7e5ae6e559e684bfcd2a45388180e6a11fba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a895c47135e5bbf83a48b2faf3bc127e9ddc13b3bde998e3899787f6991639cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bad3560274058a211d310a7d9b270e8e23dd3aa3ac90c77e79d323b8f8579ef0"
    sha256 cellar: :any_skip_relocation, sonoma:         "668600f609994a2b00e501c26e5a5d765d2524c0cf1ff99c60f46666f0ba3173"
    sha256 cellar: :any_skip_relocation, ventura:        "3aba25fa8a8bff5eb58720a65f2b0073ed62e59d7fcd5419c52108d6784ba784"
    sha256 cellar: :any_skip_relocation, monterey:       "486c409c0a0bf355578ecc7f6c4479ce64c0648913f8c08fb68383b17ad3e8d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52ed0e115ebdbe57436d8f654b78ddcdd761c90956cc32c077b88a73910394b3"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.10" => [:build, :test]
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
