class Osc < Formula
  include Language::Python::Virtualenv

  desc "The command-line interface to work with an Open Build Service"
  homepage "https://github.com/openSUSE/osc"
  url "https://github.com/openSUSE/osc/archive/0.157.2.tar.gz"
  sha256 "cde6384f069e3b08cc425cf5105251acb77f5f8c9413888b5f4ab89fec068f07"
  revision 1
  head "https://github.com/openSUSE/osc.git"

  bottle do
    cellar :any
    sha256 "270c8e8287ab6ca0972c84d8537223b3e2467e5a43074f025f84858dba6650b1" => :sierra
    sha256 "84c33037737ab5df04ecd1a04ac46c1b69d55a9b3ace6e0b523304306c3337e6" => :el_capitan
    sha256 "5a0071dbfba9979a9ba05d197fbacd02153e108eac1f6560e5385e6a5a2140c8" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "swig" => :build
  depends_on "curl"
  depends_on "openssl" # For M2Crypto

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/12/3f/557356b60d8e59a1cce62ffc07ecc03e4f8a202c86adae34d895826281fb/pycurl-7.43.0.tar.gz"
    sha256 "aa975c19b79b6aa6c0518c0cc2ae33528900478f0b500531dbcdbf05beec584c"
  end

  resource "urlgrabber" do
    url "https://files.pythonhosted.org/packages/29/1a/f509987826e17369c52a80a07b257cc0de3d7864a303175f2634c8bcb3e3/urlgrabber-3.10.2.tar.gz"
    sha256 "05b7164403d49b37fe00f7ac8401e56b00d0568ac45ee15d5f0610ac293c3070"
  end

  resource "M2Crypto" do
    url "https://files.pythonhosted.org/packages/11/29/0b075f51c38df4649a24ecff9ead1ffc57b164710821048e3d997f1363b9/M2Crypto-0.26.0.tar.gz"
    sha256 "05d94fd9b2dae2fb8e072819a795f0e05d3611b09ea185f68e1630530ec09ae8"
  end

  resource "typing" do
    url "https://files.pythonhosted.org/packages/17/75/3698d7992a828ad6d7be99c0a888b75ed173a9280e53dbae67326029b60e/typing-3.6.1.tar.gz"
    sha256 "c36dec260238e7464213dcd50d4b5ef63a507972f5780652e835d0228d0edace"
  end

  def install
    venv = virtualenv_create(libexec)
    venv.pip_install resources.reject { |r| r.name == "M2Crypto" }
    resource("M2Crypto").stage do
      inreplace "setup.py", %r{(self.openssl = )'/usr'}, "\\1'#{Formula["openssl"].prefix}'"
      venv.pip_install "."
    end

    inreplace "osc/conf.py", "'/etc/ssl/certs'", "'#{etc}/openssl/cert.pem'"
    venv.pip_install_and_link buildpath
    mv bin/"osc-wrapper.py", bin/"osc"
  end

  test do
    system bin/"osc", "--version"
  end
end
