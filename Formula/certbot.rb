class Certbot < Formula
  desc "Tool to obtain certs from Let's Encrypt and autoenable HTTPS"
  homepage "https://letsencrypt.org/"
  url "https://github.com/certbot/certbot/archive/v0.5.0.tar.gz"
  sha256 "143a7eb5bc6b1336ead2add37425170f73da471c18fb4d36c7e983e8db5251df"

  bottle do
    cellar :any
    sha256 "8bdb314b611b0d2131016f6a895fb403e62188aa8ccfc591f39cf0adac215dc1" => :el_capitan
    sha256 "ab5843dcba12498548023d2410a5352a55d54ef889c09280c6c16d139b9fcd75" => :yosemite
    sha256 "f4f63fca8928b4754a2b5a0fdcd0b777503d261d1ab87b97fdedecbece06de36" => :mavericks
  end

  depends_on "augeas"
  depends_on "dialog"
  depends_on "openssl"
  depends_on :python if MacOS.version <= :snow_leopard

  resource "setuptools" do
    url "https://pypi.python.org/packages/source/s/setuptools/setuptools-19.4.tar.gz"
    sha256 "214bf29933f47cf25e6faa569f710731728a07a19cae91ea64f826051f68a8cf"
  end

  resource "cffi" do
    url "https://pypi.python.org/packages/source/c/cffi/cffi-1.5.2.tar.gz"
    sha256 "da9bde99872e46f7bb5cff40a9b1cc08406765efafb583c704de108b6cb821dd"
  end

  resource "ConfigArgParse" do
    url "https://pypi.python.org/packages/source/C/ConfigArgParse/ConfigArgParse-0.10.0.tar.gz"
    sha256 "3b50a83dd58149dfcee98cb6565265d10b53e9c0a2bca7eeef7fb5f5524890a7"
  end

  resource "configobj" do
    url "https://pypi.python.org/packages/source/c/configobj/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "cryptography" do
    url "https://pypi.python.org/packages/source/c/cryptography/cryptography-1.3.1.tar.gz"
    sha256 "b4b36175e0f95ddc88435c26dbe3397edce48e2ff5fe41d504cdb3beddcd53e2"
  end

  resource "enum34" do
    url "https://pypi.python.org/packages/source/e/enum34/enum34-1.1.2.tar.gz"
    sha256 "2475d7fcddf5951e92ff546972758802de5260bf409319a9f1934e6bbc8b1dc7"
  end

  resource "funcsigs" do
    url "https://pypi.python.org/packages/source/f/funcsigs/funcsigs-1.0.0.tar.gz"
    sha256 "2310f9d4a77c284e920ec572dc2525366a107b08d216ff8dbb891d95b6a77563"
  end

  resource "idna" do
    url "https://pypi.python.org/packages/source/i/idna/idna-2.1.tar.gz"
    sha256 "ed36f281aebf3cd0797f163bb165d84c31507cedd15928b095b1675e2d04c676"
  end

  resource "ipaddress" do
    url "https://pypi.python.org/packages/source/i/ipaddress/ipaddress-1.0.16.tar.gz"
    sha256 "5a3182b322a706525c46282ca6f064d27a02cffbd449f9f47416f1dc96aa71b0"
  end

  resource "mock" do
    url "https://pypi.python.org/packages/source/m/mock/mock-2.0.0.tar.gz"
    sha256 "b158b6df76edd239b8208d481dc46b6afd45a846b7812ff0ce58971cf5bc8bba"
  end

  resource "ndg-httpsclient" do
    url "https://pypi.python.org/packages/source/n/ndg-httpsclient/ndg_httpsclient-0.4.0.tar.gz"
    sha256 "e8c155fdebd9c4bcb0810b4ed01ae1987554b1ee034dd7532d7b8fdae38a6274"
  end

  resource "ordereddict" do
    url "https://pypi.python.org/packages/source/o/ordereddict/ordereddict-1.1.tar.gz"
    sha256 "1c35b4ac206cef2d24816c89f89cf289dd3d38cf7c449bb3fab7bf6d43f01b1f"
  end

  resource "parsedatetime" do
    url "https://pypi.python.org/packages/source/p/parsedatetime/parsedatetime-2.1.tar.gz"
    sha256 "17c578775520c99131634e09cfca5a05ea9e1bd2a05cd06967ebece10df7af2d"
  end

  resource "pbr" do
    url "https://pypi.python.org/packages/source/p/pbr/pbr-1.8.1.tar.gz"
    sha256 "e2127626a91e6c885db89668976db31020f0af2da728924b56480fc7ccf09649"
  end

  resource "psutil" do
    url "https://pypi.python.org/packages/source/p/psutil/psutil-4.1.0.tar.gz"
    sha256 "c6abebec9c8833baaf1c51dd1b0259246d1d50b9b50e9a4aa66f33b1e98b8d17"
  end

  resource "pyasn1" do
    url "https://pypi.python.org/packages/source/p/pyasn1/pyasn1-0.1.9.tar.gz"
    sha256 "853cacd96d1f701ddd67aa03ecc05f51890135b7262e922710112f12a2ed2a7f"
  end

  resource "pycparser" do
    url "https://pypi.python.org/packages/source/p/pycparser/pycparser-2.14.tar.gz"
    sha256 "7959b4a74abdc27b312fed1c21e6caf9309ce0b29ea86b591fd2e99ecdf27f73"
  end

  resource "pyOpenSSL" do
    url "https://pypi.python.org/packages/source/p/pyOpenSSL/pyOpenSSL-16.0.0.tar.gz"
    sha256 "363d10ee43d062285facf4e465f4f5163f9f702f9134f0a5896f134cbb92d17d"
  end

  resource "pyRFC3339" do
    url "https://pypi.python.org/packages/source/p/pyRFC3339/pyRFC3339-1.0.tar.gz"
    sha256 "8dfbc6c458b8daba1c0f3620a8c78008b323a268b27b7359e92a4ae41325f535"
  end

  resource "python2-pythondialog" do
    url "https://pypi.python.org/packages/source/p/python2-pythondialog/python2-pythondialog-3.3.0.tar.bz2"
    sha256 "04e93f24995c43dd90f338d5d865ca72ce3fb5a5358d4daa4965571db35fc3ec"
  end

  resource "pytz" do
    url "https://pypi.python.org/packages/source/p/pytz/pytz-2016.3.tar.bz2"
    sha256 "c193dfa167ac32c8cb96f26cbcd92972591b22bda0bac3effdbdb04de6cc55d6"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.9.1.tar.gz"
    sha256 "c577815dd00f1394203fc44eb979724b098f88264a9ef898ee45b8e5e9cf587f"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "zope.component" do
    url "https://pypi.python.org/packages/source/z/zope.component/zope.component-4.2.2.tar.gz"
    sha256 "282c112b55dd8e3c869a3571f86767c150ab1284a9ace2bdec226c592acaf81a"
  end

  resource "zope.event" do
    url "https://pypi.python.org/packages/source/z/zope.event/zope.event-4.2.0.tar.gz"
    sha256 "ce11004217863a4827ea1a67a31730bddab9073832bdb3b9be85869259118758"
  end

  resource "zope.interface" do
    url "https://pypi.python.org/packages/source/z/zope.interface/zope.interface-4.1.3.tar.gz"
    sha256 "2e221a9eec7ccc58889a278ea13dcfed5ef939d80b07819a9a8b3cb1c681484f"
  end

  # Required because augeas formula doesn't ship these.
  resource "python-augeas" do
    url "https://pypi.python.org/packages/source/p/python-augeas/python-augeas-0.5.0.tar.gz"
    sha256 "67d59d66cdba8d624e0389b87b2a83a176f21f16a87553b50f5703b23f29bac2"
  end

  # Required for the nginx module.
  resource "pyparsing" do
    url "https://pypi.python.org/packages/source/p/pyparsing/pyparsing-2.1.1.tar.gz"
    sha256 "9bae5cd4cbee6da0d7d8d9a1647f5253a3b89652e707647eaf1961f4932ae6c6"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    # Namespace packages and .pth files aren't processed from PYTHONPATH.
    touch libexec/"vendor/lib/python2.7/site-packages/zope/__init__.py"
    touch libexec/"vendor/lib/python2.7/site-packages/ndg/__init__.py"

    cd "acme" do
      system "python", *Language::Python.setup_install_args(libexec)
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    cd "letsencrypt-apache" do
      system "python", *Language::Python.setup_install_args(libexec)
    end

    cd "letsencrypt-nginx" do
      system "python", *Language::Python.setup_install_args(libexec)
    end

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/letsencrypt --version 2>&1")
  end
end
