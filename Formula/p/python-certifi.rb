class PythonCertifi < Formula
  desc "Mozilla CA bundle for Python"
  homepage "https://github.com/certifi/python-certifi"
  url "https://files.pythonhosted.org/packages/71/da/e94e26401b62acd6d91df2b52954aceb7f561743aa5ccc32152886c76c96/certifi-2024.2.2.tar.gz"
  sha256 "0569859f95fc761b18b45ef421b1290a0f65f147e92a1e5eb3e635f9a5e4e66f"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "294ba2af10c091c85cd7d7da531bbc7080e14fc7c1096e3f87c1e8e10fec13fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5429a10dab1cb63c7ebadb563026a28b333a0b6ba74df7abcdd98387d0dde85b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "647a25b7c05a2e15cb67c50a72465c71635d58dbc8d8850a90b6aca987367701"
    sha256 cellar: :any_skip_relocation, sonoma:         "67d34f242d69fc17839289068c245d1b00a79410bf9bbe7046f19a05dc25b472"
    sha256 cellar: :any_skip_relocation, ventura:        "97bc94516a4831e5ae693b9c54a9bbb4302f6aa7e9c6f2260295740f2a645a5a"
    sha256 cellar: :any_skip_relocation, monterey:       "6c89ecc6566b03fd9ad226ca829704eef938d0ccaf0ae642736dd87277d3034f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d4624e1e5b2baede34b7bf7f13a52457e693a6980fd5d5328b2d1cf15797858"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "ca-certificates"

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."

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
