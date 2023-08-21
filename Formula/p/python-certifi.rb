class PythonCertifi < Formula
  desc "Mozilla CA bundle for Python"
  homepage "https://github.com/certifi/python-certifi"
  url "https://files.pythonhosted.org/packages/98/98/c2ff18671db109c9f10ed27f5ef610ae05b73bd876664139cf95bd1429aa/certifi-2023.7.22.tar.gz"
  sha256 "539cc1d13202e33ca466e88b2807e29f4c13049d6d87031a3c110744495cb082"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7878fa87dfc11f074a00e30691dc749135c15fbb999ec16fdb3dac7255390e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7878fa87dfc11f074a00e30691dc749135c15fbb999ec16fdb3dac7255390e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7878fa87dfc11f074a00e30691dc749135c15fbb999ec16fdb3dac7255390e8"
    sha256 cellar: :any_skip_relocation, ventura:        "14df2281408c868092a8466c2625c46c6c73bef3e589905a2c3394b0fe4e3c4f"
    sha256 cellar: :any_skip_relocation, monterey:       "14df2281408c868092a8466c2625c46c6c73bef3e589905a2c3394b0fe4e3c4f"
    sha256 cellar: :any_skip_relocation, big_sur:        "14df2281408c868092a8466c2625c46c6c73bef3e589905a2c3394b0fe4e3c4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1b2b275104c40f39c6470e874e4476716480c82ac4bdb4e65494e4e653ce82c"
  end

  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.9" => [:build, :test]
  depends_on "ca-certificates"

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, *Language::Python.setup_install_args(prefix, python_exe)

      # Use brewed ca-certificates PEM file instead of the bundled copy
      site_packages = Language::Python.site_packages("python#{python.version.major_minor}")
      rm prefix/site_packages/"certifi/cacert.pem"
      (prefix/site_packages/"certifi").install_symlink Formula["ca-certificates"].pkgetc/"cert.pem" => "cacert.pem"
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      output = shell_output("#{python_exe} -m certifi").chomp
      assert_equal Formula["ca-certificates"].pkgetc/"cert.pem", Pathname(output).realpath
    end
  end
end
