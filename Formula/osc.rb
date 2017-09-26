class Osc < Formula
  include Language::Python::Virtualenv

  desc "The command-line interface to work with an Open Build Service"
  homepage "https://github.com/openSUSE/osc"
  url "https://github.com/openSUSE/osc/archive/0.160.0.tar.gz"
  sha256 "8190d362ecce258b721a45a110c82128115573254c2ad72066280684efd148db"
  head "https://github.com/openSUSE/osc.git"

  bottle do
    cellar :any
    sha256 "57f09ae1c049b500cf8fe4240aa0f093c4a6562635898a7af06950b052d0ba49" => :sierra
    sha256 "5ad7d2739d48eb474aab764f6dc170a2bfd671d29338a4940f887467fdfe28dc" => :el_capitan
    sha256 "0b0de3aa214f57e3a180c485c4649e34dbeed073ec038acb7178342c2a8e7ce3" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "swig" => :build
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
    url "https://files.pythonhosted.org/packages/dc/5b/1ff81e2dda5d2dee62d1c26f5df91b1ea3a560b6611cea67e6c55d1f2e15/M2Crypto-0.26.4.tar.gz"
    sha256 "5cae7acc0b34821f8c0ddf6665e482893fe1f198ad6379e61ffa9d8e65f5c199"
  end

  resource "typing" do
    url "https://files.pythonhosted.org/packages/ca/38/16ba8d542e609997fdcd0214628421c971f8c395084085354b11ff4ac9c3/typing-3.6.2.tar.gz"
    sha256 "d514bd84b284dd3e844f0305ac07511f097e325171f6cc4a20878d11ad771849"
  end

  def install
    # avoid pycurl error about compile-time and link-time curl version mismatch
    ENV.delete "SDKROOT"

    venv = virtualenv_create(libexec)
    venv.pip_install resources.reject { |r| r.name == "M2Crypto" || r.name == "pycurl" }

    resource("M2Crypto").stage do
      inreplace "setup.py", %r{(self.openssl = )'/usr'}, "\\1'#{Formula["openssl"].prefix}'"
      venv.pip_install "."
    end

    # avoid error about libcurl link-time and compile-time ssl backend mismatch
    resource("pycurl").stage do
      system libexec/"bin/pip", "install",
             "--install-option=--libcurl-dll=/usr/lib/libcurl.dylib", "-v",
             "--no-binary", ":all:", "--ignore-installed", "."
    end

    inreplace "osc/conf.py", "'/etc/ssl/certs'", "'#{etc}/openssl/cert.pem'"
    venv.pip_install_and_link buildpath
    mv bin/"osc-wrapper.py", bin/"osc"
  end

  test do
    system bin/"osc", "--version"
  end
end
