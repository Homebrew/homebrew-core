class Certifi < Formula
  desc "Mozilla CA bundle for Python"
  homepage "https://github.com/certifi/python-certifi"
  url "https://files.pythonhosted.org/packages/b0/ee/9b19140fe824b367c04c5e1b369942dd754c4c5462d5674002f75c4dedc1/certifi-2024.8.30.tar.gz"
  sha256 "bec941d2aa8195e248a60b31ff9f0558284cf01a52591ceda73ea9afffd69fd9"
  license "MPL-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f1fc985a1c89bd40c73b17e3dfbf5483cb0417c8d4d12e2be66158a503ab169"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f1fc985a1c89bd40c73b17e3dfbf5483cb0417c8d4d12e2be66158a503ab169"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f1fc985a1c89bd40c73b17e3dfbf5483cb0417c8d4d12e2be66158a503ab169"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f1667b45b868ff09a3eb9f672c20299d7b49add64a1c6cf8d675b6b3ff5d5ba"
    sha256 cellar: :any_skip_relocation, ventura:       "1f1667b45b868ff09a3eb9f672c20299d7b49add64a1c6cf8d675b6b3ff5d5ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f1fc985a1c89bd40c73b17e3dfbf5483cb0417c8d4d12e2be66158a503ab169"
  end

  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]
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
