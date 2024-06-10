class Certifi < Formula
  desc "Mozilla CA bundle for Python"
  homepage "https://github.com/certifi/python-certifi"
  url "https://files.pythonhosted.org/packages/07/b3/e02f4f397c81077ffc52a538e0aec464016f1860c472ed33bd2a1d220cc5/certifi-2024.6.2.tar.gz"
  sha256 "3cd43f1c6fa7dedc5899d69d3ad0398fd018ad1a17fba83ddaf78aa46c747516"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "09d9ee1944c9578779c2ba70082d624d626809cf31a6a9d67c174db98567a35b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09d9ee1944c9578779c2ba70082d624d626809cf31a6a9d67c174db98567a35b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09d9ee1944c9578779c2ba70082d624d626809cf31a6a9d67c174db98567a35b"
    sha256 cellar: :any_skip_relocation, sonoma:         "3c9222fc5169b0fe356bd8e4c776a1158b7cfd5f8c862ab0132f6da7bd8ca22c"
    sha256 cellar: :any_skip_relocation, ventura:        "3c9222fc5169b0fe356bd8e4c776a1158b7cfd5f8c862ab0132f6da7bd8ca22c"
    sha256 cellar: :any_skip_relocation, monterey:       "3c9222fc5169b0fe356bd8e4c776a1158b7cfd5f8c862ab0132f6da7bd8ca22c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09d9ee1944c9578779c2ba70082d624d626809cf31a6a9d67c174db98567a35b"
  end

  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "ca-certificates"

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."

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
