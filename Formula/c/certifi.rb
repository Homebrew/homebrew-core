class Certifi < Formula
  desc "Mozilla CA bundle for Python"
  homepage "https://github.com/certifi/python-certifi"
  url "https://files.pythonhosted.org/packages/c2/02/a95f2b11e207f68bc64d7aae9666fed2e2b3f307748d5123dffb72a1bbea/certifi-2024.7.4.tar.gz"
  sha256 "5a1e7645bc0ec61a09e26c36f6106dd4cf40c6db3a1fb6352b0244e7fb057c7b"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4106d660c4417641c4384ee68ab6c4146da998c22da4798ff94b03acd9ea31b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4106d660c4417641c4384ee68ab6c4146da998c22da4798ff94b03acd9ea31b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4106d660c4417641c4384ee68ab6c4146da998c22da4798ff94b03acd9ea31b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "eecaf796430a3551f53fbe900e1455236af45d3996940288788293cda464dd92"
    sha256 cellar: :any_skip_relocation, ventura:        "eecaf796430a3551f53fbe900e1455236af45d3996940288788293cda464dd92"
    sha256 cellar: :any_skip_relocation, monterey:       "a33c294eb85e0ec0aadffe848e9b2be405c676a8435c50c7f9ddb5891ab633b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4106d660c4417641c4384ee68ab6c4146da998c22da4798ff94b03acd9ea31b4"
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
