class Binwalk < Formula
  desc "Searches a binary image for embedded files and executable code"
  homepage "https://github.com/devttys0/binwalk"
  url "https://github.com/devttys0/binwalk/archive/v2.1.1.tar.gz"
  sha256 "1b70a5b03489d29f60fef18008a2164974234874faab48a4f47ec53d461d284a"
  revision 4

  head "https://github.com/devttys0/binwalk.git"

  bottle do
    sha256 "8c5c20fa4f9744e2461882c2c7a77b8532885583e10c0f943d3a92c1299450b1" => :high_sierra
    sha256 "eb564bd84ee2d904ccc6e054e66c3d3f2d9f40f62845fbe84c426536ba8b71f8" => :sierra
    sha256 "551c2949f58da9f864e19a088f421785792bb51bbebecc3b457155846a2dd69f" => :el_capitan
  end

  option "with-capstone", "Enable disasm options via capstone"

  depends_on "swig" => :build
  depends_on "gcc" # for gfortran
  depends_on "p7zip"
  depends_on "python" if MacOS.version <= :snow_leopard
  depends_on "ssdeep"
  depends_on "xz"

  resource "numpy" do
    url "https://pypi.python.org/packages/source/n/numpy/numpy-1.10.2.tar.gz"
    sha256 "23a3befdf955db4d616f8bb77b324680a80a323e0c42a7e8d7388ef578d8ffa9"
  end

  resource "scipy" do
    url "https://downloads.sourceforge.net/project/scipy/scipy/0.16.1/scipy-0.16.1.tar.gz"
    sha256 "ecd1efbb1c038accb0516151d1e6679809c6010288765eb5da6051550bf52260"
  end

  resource "capstone" do
    url "https://files.pythonhosted.org/packages/44/3f/2ae09118f1c890b98e7b87ff1ce3d3a36e8e72ddac74ddcf0bbe8f005210/capstone-3.0.5rc2.tar.gz"
    sha256 "c67a4e14d04b29126f6ae2a4aeb773acf96cc6705e1fa7bd9af1798fa928022a"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    res = %w[numpy scipy]
    res += %w[capstone] if build.with? "capstone"
    res.each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    touch "binwalk.test"
    system "#{bin}/binwalk", "binwalk.test"
  end
end
