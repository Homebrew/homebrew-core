class Osc < Formula
  desc "The Command Line Interface to work with an Open Build Service"
  homepage "https://github.com/openSUSE/osc"
  url "https://github.com/openSUSE/osc/archive/0.155.1.tar.gz"
  sha256 "bd392cf601fade0770e2b1fef2a964dfaa02ee002a615708f230549708f26acc"
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
  depends_on "curl"
  depends_on "openssl" # For M2Crypto

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/12/3f/557356b60d8e59a1cce62ffc07ecc03e4f8a202c86adae34d895826281fb/pycurl-7.43.0.tar.gz"
    sha256 "aa975c19b79b6aa6c0518c0cc2ae33528900478f0b500531dbcdbf05beec584c"
  end

  resource "urlgrabber" do
    url "https://files.pythonhosted.org/packages/3c/fd/710150d9647e32f1eafe9d60ff55553a8754e185c791781da0246c7d6b57/urlgrabber-3.9.1.tar.gz"
    sha256 "b4e276fa968c66671309a6d754c4b3b0cb2003dec8bca87a681378a22e0d3da7"
  end

  resource "M2Crypto" do
    url "https://files.pythonhosted.org/packages/9c/58/7e8d8c04995a422c3744929721941c400af0a2a8b8633f129d92f313cfb8/M2Crypto-0.25.1.tar.gz"
    sha256 "ac303a1881307a51c85ee8b1d87844d9866ee823b4fdbc52f7e79187c2d9acef"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        inreplace "setup.py", "self.openssl = '/usr'", "self.openssl = '#{Formula["openssl"].opt_prefix}'" if r.name == "M2Crypto"
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
