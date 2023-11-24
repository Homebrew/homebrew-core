class PythonPkgconfig < Formula
  desc "Interface Python with pkg-config"
  homepage "https://github.com/matze/pkgconfig"
  url "https://files.pythonhosted.org/packages/c4/e0/e05fee8b5425db6f83237128742e7e5ef26219b687ab8f0d41ed0422125e/pkgconfig-1.5.5.tar.gz"
  sha256 "deb4163ef11f75b520d822d9505c1f462761b4309b1bb713d08689759ea8b899"
  license "MIT"

  depends_on "poetry" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    inreplace "pyproject.toml", 'pytest = "^3.8.2"', ""
    site_packages = Language::Python.site_packages("python@3.12")
    ENV.append_path "PYTHONPATH", Formula["poetry"].opt_libexec/site_packages
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      system python.opt_libexec/"bin/python", "-c", "import pkgconfig"
    end
  end
end
