class Certifi < Formula
  desc "Mozilla CA bundle for Python"
  homepage "https://github.com/certifi/python-certifi"
  url "https://files.pythonhosted.org/packages/dc/67/960ebe6bf230a96cda2e0abcf73af550ec4f090005363542f0765df162e0/certifi-2025.8.3.tar.gz"
  sha256 "e564105f78ded564e3ae7c923924435e1daa7463faeab5bb932bc53ffae63407"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b9364932b2e97249a92c11076b9cabe13ac5fdad56eac069f3ad33c02c53b8f0"
  end

  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]
  depends_on "ca-certificates"

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    # Avoid difference in generated METADATA files across bottles
    inreplace "README.rst", "/usr/local", HOMEBREW_PREFIX

    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."

      # Use brewed ca-certificates PEM file instead of the bundled copy
      site_packages = Language::Python.site_packages("python#{python.version.major_minor}")
      rm prefix/site_packages/"certifi/cacert.pem"
      (prefix/site_packages/"certifi").install_symlink Formula["ca-certificates"].pkgetc/"cert.pem" => "cacert.pem"
    end

    # Revert first inreplace to avoid difference in README.rst across bottles
    inreplace "README.rst", HOMEBREW_PREFIX, "/usr/local"
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      output = shell_output("#{python_exe} -m certifi").chomp
      assert_equal Formula["ca-certificates"].pkgetc/"cert.pem", Pathname(output).realpath
    end
  end
end
