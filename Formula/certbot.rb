class Certbot < Formula
  include Language::Python::Virtualenv

  desc "Tool to obtain certs from Let's Encrypt and autoenable HTTPS"
  homepage "https://certbot.eff.org/"
  url "https://github.com/certbot/certbot/archive/v1.8.0.tar.gz"
  sha256 "ce7381c0110d0876615a869c0b11d900ec4a84c316cc2a4d78d1bc6aaa2592cb"
  license "Apache-2.0"
  head "https://github.com/certbot/certbot.git"

  bottle do
    cellar :any
    sha256 "52efea97de783aa952ba96439b7c3f517db0a6f5953a4a1e01bb88865fe06ecf" => :catalina
    sha256 "37956df6f6fd93a789cc5bee3070d5381abe951a59c83c033be5f7010f53c43e" => :mojave
    sha256 "d4703a4006a1aa90090c75f5279532dd203ffd3d7924fa1672ca1ba0465f1f16" => :high_sierra
  end

  depends_on "augeas"
  depends_on "dialog"
  depends_on "openssl@1.1"
  depends_on "python@3.8"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "acme" do
    url "https://files.pythonhosted.org/packages/85/07/659705c6b18c77a0299edbf74bebcc7c02a31d979c0d9ff01d15125d4be7/acme-1.8.0.tar.gz"
    sha256 "ad8d067d14258d73ad2643439d9365913362308c04e66cc3010e39c868c5002d"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/40/a7/ded59fa294b85ca206082306bba75469a38ea1c7d44ea7e1d64f5443d67a/certifi-2020.6.20.tar.gz"
    sha256 "5930595817496dd21bb8dc35dad090f1c2cd0adfaf21204bf6732ca5d8ee34d3"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/f7/09/88bbe20b76ca76be052c366fe77aa5e3cd6e5f932766e5597fecdd95b2a8/cffi-1.14.2.tar.gz"
    sha256 "ae8f34d50af2c2154035984b8b5fc5d9ed63f32fe615646ab435b05b132ca91b"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "ConfigArgParse" do
    url "https://files.pythonhosted.org/packages/bb/79/3045743bb26ca2e44a1d317c37395462bfed82dbbd38e69a3280b63696ce/ConfigArgParse-1.2.3.tar.gz"
    sha256 "edd17be986d5c1ba2e307150b8e5f5107aba125f3574dddd02c85d5cdcfd37dc"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/12/be/c9cc7d7ab71dbcc9e4e517ead0cdd48e8c9a48d7b8bdddb738e90d08279a/cryptography-3.1.tar.gz"
    sha256 "26409a473cc6278e4c90f782cd5968ebad04d3911ed1c402fc86908c17633e08"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/a6/a4/75064c334d8ae433445a20816b788700db1651f21bdb0af33db2aab142fe/distro-1.5.0.tar.gz"
    sha256 "0e58756ae38fbd8fc3020d54badb8eae17c5b9dcbed388b17bb55b8a5928df92"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "josepy" do
    url "https://files.pythonhosted.org/packages/0b/72/616c591e74eb5f9570dd636f91dfddd0d4613088ce43e581e80b826dc964/josepy-1.4.0.tar.gz"
    sha256 "c37ff4b93606e6a452b72cdb992da5e0544be12912fac01b31ddbdd61f6d5bd0"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/a8/20/cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312ac/parsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/0d/1d/6cc4bd4e79f78be6640fab268555a11af48474fac9df187c3361a1d1d2f0/pyOpenSSL-19.1.0.tar.gz"
    sha256 "9a24494b2602aaf402be5c9e30a0b82d4a5c67528fe8fb475e3f3bc00dd69507"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "pyRFC3339" do
    url "https://files.pythonhosted.org/packages/00/52/75ea0ae249ba885c9429e421b4f94bc154df68484847f1ac164287d978d7/pyRFC3339-1.1.tar.gz"
    sha256 "81b8cbe1519cdb79bed04910dd6fa4e181faf8c88dff1e1b987b5f7ab23a5b1a"
  end

  resource "python-augeas" do
    url "https://files.pythonhosted.org/packages/af/cc/5064a3c25721cd863e6982b87f10fdd91d8bcc62b6f7f36f5231f20d6376/python-augeas-1.1.0.tar.gz"
    sha256 "5194a49e86b40ffc57055f73d833f87e39dce6fce934683e7d0d5bbb8eff3b8c"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f4/f6/94fee50f4d54f58637d4b9987a1b862aeb6cd969e73623e02c5c00755577/pytz-2020.1.tar.gz"
    sha256 "c35965d010ce31b23eeb663ed3cc8c906275d6be1a34393a1d73a41febf4a048"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/da/67/672b422d9daf07365259958912ba533a0ecab839d4084c487a5fe9a5405f/requests-2.24.0.tar.gz"
    sha256 "b3559a131db72c33ee969480840fff4bb6dd111de7dd27c8ee1f820f4f00231b"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/28/30/7bf7e5071081f761766d46820e52f4b16c8a08fef02d2eb4682ca7534310/requests-toolbelt-0.9.1.tar.gz"
    sha256 "968089d4584ad4ad7c171454f0a5c6dac23971e9472521ea3b6d49d610aa6fc0"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/81/f4/87467aeb3afc4a6056e1fe86626d259ab97e1213b1dfec14c7cb5f538bf0/urllib3-1.25.10.tar.gz"
    sha256 "91056c15fa70756691db97756772bb1eb9678fa585d9184f24534b100dc60f4a"
  end

  resource "zope.component" do
    url "https://files.pythonhosted.org/packages/5d/e7/14935f56295e6a9a4ebcc82e30403f4bf580760801ea7ac6bae61ef0267b/zope.component-4.6.2.tar.gz"
    sha256 "91628918218b3e6f6323de2a7b845e09ddc5cae131c034896c051b084bba3c92"
  end

  resource "zope.deferredimport" do
    url "https://files.pythonhosted.org/packages/b9/74/6eb2dcf013fac35d086abef2435b5a6621435c2b0c166ef5b63a1b51e91d/zope.deferredimport-4.3.1.tar.gz"
    sha256 "57b2345e7b5eef47efcd4f634ff16c93e4265de3dcf325afc7315ade48d909e1"
  end

  resource "zope.deprecation" do
    url "https://files.pythonhosted.org/packages/34/da/46e92d32d545dd067b9436279d84c339e8b16de2ca393d7b892bc1e1e9fd/zope.deprecation-4.4.0.tar.gz"
    sha256 "0d453338f04bacf91bbfba545d8bcdf529aa829e67b705eac8c1a7fdce66e2df"
  end

  resource "zope.event" do
    url "https://files.pythonhosted.org/packages/4c/b2/51c0369adcf5be2334280eed230192ab3b03f81f8efda9ddea6f65cc7b32/zope.event-4.4.tar.gz"
    sha256 "69c27debad9bdacd9ce9b735dad382142281ac770c4a432b533d6d65c4614bcf"
  end

  resource "zope.hookable" do
    url "https://files.pythonhosted.org/packages/31/ce/4d1cd6d2a3d980989ceaf86abb6c8683f90f01a81861f3de6ec7ae317db7/zope.hookable-5.0.1.tar.gz"
    sha256 "29d07681a78042cdd15b268ae9decffed9ace68a53eebeb61d65ae931d158841"
  end

  resource "zope.interface" do
    url "https://files.pythonhosted.org/packages/af/d2/9675302d7ced7ec721481f4bbecd28a390a8db4ff753d28c64057b975396/zope.interface-5.1.0.tar.gz"
    sha256 "40e4c42bd27ed3c11b2c983fecfb03356fae1209de10686d03c02c8696a1d90e"
  end

  resource "zope.proxy" do
    url "https://files.pythonhosted.org/packages/ab/37/26899cb231ecfa04822a17a669eac6df7ef0c2a86e2b78001db0cd3edd46/zope.proxy-4.3.5.tar.gz"
    sha256 "a66a0d94e5b081d5d695e66d6667e91e74d79e273eee95c1747717ba9cb70792"
  end

  resource "setuptools" do
    # https://github.com/pypa/setuptools/issues/2017#issuecomment-605354361
    on_linux do
      url "https://files.pythonhosted.org/packages/fd/76/3c7f726ed5c582019937f178d7478ce62716b7e8263344f1684cbe11ab3e/setuptools-45.0.0.zip"
      sha256 "c46d9c8f2289535457d36c676b541ca78f7dcb736b97d02f50d17f7f15b583cc"
    end
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resources.each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    # Install in our prefix, not the first-in-the-path python site-packages dir.
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"

    cd buildpath/"certbot" do
      system "python3", *Language::Python.setup_install_args(libexec)
    end

    # Shipped with certbot, not external resources.
    %w[acme certbot-apache certbot-nginx].each do |r|
      cd buildpath/r do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end
    pkgshare.install buildpath/"certbot/examples"

    bin.install Dir[libexec/"bin/certbot"]
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/certbot --version 2>&1")
    # This throws a bad exit code but we can check it actually is failing
    # for the right reasons by asserting. --version never fails even if
    # resources are missing or outdated/too new/etc.
    assert_match "Either run as root", shell_output("#{bin}/certbot 2>&1", 1)
  end
end
