class Biogeme < Formula
  desc "Maximum likelihood estimation of choice models"
  homepage "https://biogeme.epfl.ch/"
  url "https://files.pythonhosted.org/packages/0a/8b/1228805ea0ad03dbfac3c15e22be6451b09a40438524cf2bff2aeeb4075d/biogeme-3.2.5.tar.gz"
  sha256 "cbee2d318dddb6cf4bd6714961435aae201440b78185f2bc3eeab16cf28a98d6"
  revision 6

  bottle do
    cellar :any
    sha256 "78b929e88aa59e057b7c4cc65a17ae1f9d3a88f5a521ea3709d0c8c82f9aa097" => :catalina
    sha256 "669b97da46ec4e508169b764b6c801682f9282702ec6f17d32f9e4b7426cf8dc" => :mojave
    sha256 "b90e3f0d203a5ad33d2ad1f70e12503a93784bb4a97d78b284c0d4c746666ea5" => :high_sierra
    sha256 "cad38740685b800f07bece9dd13238b900427155697582fc689bd3eee42e8c38" => :sierra
  end

  # depends_on "cython" => :build
  depends_on "python@3.8"
  depends_on "numpy"
  depends_on "scipy"

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/79/36/69246177114d0b6cb7bd4f9aef177b434c0f4a767e05201b373e8c8d7092/Cython-0.29.19.tar.gz"
    sha256 "97f98a7dc0d58ea833dc1f8f8b3ce07adf4c0f030d1886c5399a2135ed415258"
  end

  resource "Unidecode" do
    url "https://files.pythonhosted.org/packages/b1/d6/7e2a98e98c43cf11406de6097e2656d31559f788e9210326ce6544bd7d40/Unidecode-1.1.1.tar.gz"
    sha256 "2b6aab710c2a1647e928e36d69c21e76b453cd455f4e2621000e54b2a9b8cce8"
  end

  resource "pandas" do
    url "https://files.pythonhosted.org/packages/2f/79/f236ab1cfde94bac03d7b58f3f2ab0b1cc71d6a8bda3b25ce370a9fe4ab1/pandas-1.0.3.tar.gz"
    sha256 "32f42e322fb903d0e189a4c10b75ba70d90958cc4f66a1781ed027f1a1d14586"
  end

  def install
    xy = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"

    vendor_site_packages = libexec/"vendor/lib/python#{xy}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", vendor_site_packages

    ENV.prepend_create_path "PYTHONPATH", buildpath/"cython/lib/python#{xy}/site-packages"
    resource("Cython").stage do
      system Formula["python@3.8"].opt_bin/"python3", *Language::Python.setup_install_args(buildpath/"cython")
    end
    %w[numpy scipy].each do |d|
      ENV.prepend "PYTHONPATH", Formula[d].opt_lib/"python#{xy}/site-packages"
    end

    resources.each do |r|
      next if r.name == "Cython"
      r.stage do
        system Formula["python@3.8"].opt_bin/"python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    site_packages = libexec/"lib/python#{xy}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", site_packages
    system Formula["python@3.8"].opt_bin/"python3", *Language::Python.setup_install_args(libexec)
  end

  test do
    (testpath/"minimal.py").write <<~EOS
      from biogeme import *
      rowIterator('obsIter')
      BIOGEME_OBJECT.SIMULATE = Enumerate({'Test':1},'obsIter')
    EOS
    (testpath/"minimal.dat").write <<~EOS
      TEST
      1
    EOS
    system bin/"pythonbiogeme", "minimal", "minimal.dat"
  end
end
