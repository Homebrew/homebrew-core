class Osc < Formula
  include Language::Python::Virtualenv

  desc "The Command Line Interface to work with an Open Build Service"
  homepage "https://github.com/openSUSE/osc"
  url "https://github.com/openSUSE/osc/archive/0.157.2.tar.gz"
  sha256 "cde6384f069e3b08cc425cf5105251acb77f5f8c9413888b5f4ab89fec068f07"
  head "https://github.com/openSUSE/osc.git"

  bottle do
    cellar :any
    sha256 "2fb7940ff685c9c718a1f213039f6c6ceac2a7b6b30a3a527ffacb53a9256ec8" => :sierra
    sha256 "e440940de123fbd52690a99e51575d5426dc91c3f79450c58f3f1b174963c315" => :el_capitan
    sha256 "d0d4f711e22a0f1641b2e81336a07e5bc2f9870a1bb9f6a35646251b7c524213" => :yosemite
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
    url "https://files.pythonhosted.org/packages/9c/58/7e8d8c04995a422c3744929721941c400af0a2a8b8633f129d92f313cfb8/M2Crypto-0.25.1.tar.gz"
    sha256 "ac303a1881307a51c85ee8b1d87844d9866ee823b4fdbc52f7e79187c2d9acef"
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
