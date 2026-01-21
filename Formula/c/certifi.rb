class Certifi < Formula
  desc "Mozilla CA bundle for Python"
  homepage "https://github.com/certifi/python-certifi"
  url "https://files.pythonhosted.org/packages/e0/2d/a891ca51311197f6ad14a7ef42e2399f36cf2f9bd44752b3dc4eab60fdc5/certifi-2026.1.4.tar.gz"
  sha256 "ac726dd470482006e014ad384921ed6438c457018f4b3d204aea4281258b2120"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4706ecc482a52f5e655b1959ef45084edd262414f509ead840215f01e330d201"
  end

  depends_on "python@3.14" => [:build, :test]
  depends_on "python@3.12" => :test # keep on oldest python to support (externally managed and not EOL)
  depends_on "ca-certificates"

  def pythons
    deps.filter_map { |dep| dep.to_formula if dep.name.start_with?("python@") }
  end

  def install
    oldest_python, python = pythons.sort_by(&:version)
    python_exe = python.opt_libexec/"bin/python"
    system python_exe, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."

    # Use brewed ca-certificates PEM file instead of the bundled copy
    site_packages = prefix/Language::Python.site_packages(python_exe)
    rm site_packages/"certifi/cacert.pem"
    (site_packages/"certifi").install_symlink Formula["ca-certificates"].pkgetc/"cert.pem" => "cacert.pem"

    python.versioned_formulae.each do |extra_python|
      next if extra_python.version < oldest_python.version

      # Cannot use Python.site_packages as that requires formula to be installed
      extra_site_packages = lib/"python#{extra_python.version.major_minor}/site-packages"
      site_packages.find do |path|
        (extra_site_packages/path.relative_path_from(site_packages)).dirname.install_symlink path if path.file?
      end
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
