class Osc < Formula
  desc "The Command Line Interface to work with an Open Build Service"
  homepage "https://github.com/openSUSE/osc"
  url "https://github.com/openSUSE/osc/archive/0.154.0.tar.gz"
  sha256 "88daae5b94354e9bcab03523aa7e3d270f69ffeaef8e4a1493bce19757d4699d"
  head "https://github.com/openSUSE/osc.git"

  bottle do
    cellar :any
    sha256 "ccf67f3a3618993311f0be3b65394008ca3ede00267f232c5aab396501b1c10e" => :sierra
    sha256 "c222f3a00e708e82946f1b60a13c3203a5a76b0cb762ce0ba2d45f0eae6ce0b2" => :el_capitan
    sha256 "d4527195fd393ae22bf47539b75f9e58f3e8b7dda6a2c188dd6dccc4fd6218ad" => :yosemite
    sha256 "f60c8850b29deb453fe7ea6f58a262bd8070ebedfb7ef9a3844fe35056315afe" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "swig" => :build
  depends_on "openssl" # For M2Crypto

  resource "pycurl" do
    url "https://dl.bintray.com/pycurl/pycurl/pycurl-7.43.0.tar.gz"
    sha256 "aa975c19b79b6aa6c0518c0cc2ae33528900478f0b500531dbcdbf05beec584c"
  end

  resource "urlgrabber" do
    url "http://urlgrabber.baseurl.org/download/urlgrabber-3.10.1.tar.gz"
    sha256 "06b13ff8d527dba3aee04069681b2c09c03117592d5485a80ae4b807cdf33476"
  end

  resource "m2crypto" do
    url "https://pypi.python.org/packages/packages/source/M/M2Crypto/M2Crypto-0.24.0.tar.gz"
    sha256 "80a56441a1d2c0cf27e725be7554c92598b938fc8767ee2c71fdbc2fdc055ee8"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        inreplace "setup.py", "self.openssl = '/usr'", "self.openssl = '#{Formula["openssl"].opt_prefix}'" if r.name == "m2crypto"
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    # Fix for Homebrew's custom OpenSSL cert path.
    inreplace "osc/conf.py", "'/etc/ssl/certs'", "'#{etc}/openssl/cert.pem'"

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(prefix)

    bin.install "osc-wrapper.py" => "osc"
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system bin/"osc", "--version"
  end
end
