class PythonPycurl < Formula
  desc "Python Interface To libcurl"
  homepage "http://pycurl.io/"
  url "https://files.pythonhosted.org/packages/a8/af/24d3acfa76b867dbd8f1166853c18eefc890fc5da03a48672b38ea77ddae/pycurl-7.45.2.tar.gz"
  sha256 "5730590be0271364a5bddd9e245c9cc0fb710c4cbacbdd95264a3122d23224ca"
  license any_of: ["LGPL-2.1-or-later", "MIT"]
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a0a91bf7dc83a150d0374bfff26973da20c190dda21df2a5acda1b7b13cf4e54"
    sha256 cellar: :any,                 arm64_ventura:  "012ce20c9890fee19de85bbcbace869cb3759a368ae5ea10f76b09291cc9e4a3"
    sha256 cellar: :any,                 arm64_monterey: "59ad8758dcde881473ee0c6beae3e7492aca5cb316449ad1d00a27f14c2a668b"
    sha256 cellar: :any,                 sonoma:         "2f532d0968235ef9505e5b66625ae8e44207d3b1608a9d4bcb32f703a37979f9"
    sha256 cellar: :any,                 ventura:        "757ae70355c60c0d1b62a3f6a41c1fd7692cd01b1793761465025025114e5d91"
    sha256 cellar: :any,                 monterey:       "6c7e641d0618c56fb64377a5c8c51e828ef3d983edf220f487961eb2103b0131"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67741a50449eb6773eb30936396976d057db0047e9f1e93c8b37748a67386f8d"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.10" => [:build, :test]
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
